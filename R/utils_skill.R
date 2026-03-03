skill_paths <- list(
  claude_code = list(
    project = '.claude/skills',
    global = '~/.claude/skills'
  ),
  openclaw = list(
    project = '.openclaw/skills',
    global = '~/.openclaw/skills'
  ),
  codex = list(
    project = '.codex/skills',
    global = '~/.codex/skills'
  ),
  cursor = list(
    project = '.cursor/skills',
    global = '~/.cursor/skills'
  ),
  gemini_cli = list(
    project = '.gemini/skills',
    global = '~/.gemini/skills'
  ),
  github_copilot = list(
    project = '.copilot/skills',
    global = '~/.copilot/skills'
  )
)

lock_file <- '.skill-lock.json'

agent_aliases <- list(claude = 'claude_code')

agent_indicators <- c(
  claude_code    = '.claude',
  openclaw       = '.openclaw',
  codex          = '.codex',
  cursor         = '.cursor',
  gemini_cli     = '.gemini',
  github_copilot = '.copilot'
)

detect_agent <- function() {
  found <- names(agent_indicators)[fs::dir_exists(agent_indicators)]
  if (length(found) == 0) {
    return(NULL)
  }
  found[[1]]
}

# Classify a skill source as "github" or "local"
parse_source <- function(source) {
  if (grepl('^https?://github\\.com/|^https?://gitlab\\.com/', source)) {
    'github'
  } else if (grepl('^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$', source)) {
    'github'
  } else {
    'local'
  }
}

# Parse owner, repo, and optional subdirectory path from a GitHub source string.
# Accepts:
#   "owner/repo"
#   "https://github.com/owner/repo"
#   "https://github.com/owner/repo.git"
#   "https://github.com/owner/repo/tree/branch/path/to/skill"
parse_gh_source <- function(source) {
  source <- sub('\\.git$', '', source)
  if (grepl('^https?://github\\.com/', source)) {
    parts <- strsplit(sub('^https?://github\\.com/', '', source), '/')[[1]]
    owner <- parts[[1]]
    repo <- parts[[2]]
    # /tree/{branch}/{path...} → extract path
    if (length(parts) >= 5 && parts[[3]] == 'tree') {
      path <- paste(parts[5:length(parts)], collapse = '/')
    } else {
      path <- NULL
    }
    list(owner = owner, repo = repo, path = path)
  } else {
    parts <- strsplit(source, '/')[[1]]
    list(owner = parts[[1]], repo = parts[[2]], path = NULL)
  }
}

# Parse YAML frontmatter from a SKILL.md file; returns a named list
read_skill_meta <- function(skill_dir) {
  skill_file <- fs::path(skill_dir, 'SKILL.md')
  if (!fs::file_exists(skill_file)) {
    cli::cli_abort('No {.file SKILL.md} found in {.path {skill_dir}}.')
  }
  lines <- readLines(skill_file, warn = FALSE)
  if (length(lines) == 0 || lines[[1]] != '---') {
    return(list(name = NULL, description = NULL))
  }
  end <- which(lines == '---')
  if (length(end) < 2) {
    return(list(name = NULL, description = NULL))
  }
  yaml_text <- paste(lines[2:(end[[2]] - 1)], collapse = '\n')
  yaml::yaml.load(yaml_text)
}

# Validate that a directory is a valid skill (has SKILL.md with name + description)
validate_skill_dir <- function(skill_dir) {
  meta <- read_skill_meta(skill_dir)
  if (is.null(meta$name) || !nzchar(meta$name)) {
    cli::cli_abort(
      '{.file SKILL.md} in {.path {skill_dir}} is missing a {.field name} field.'
    )
  }
  if (is.null(meta$description) || !nzchar(meta$description)) {
    cli::cli_abort(
      '{.file SKILL.md} in {.path {skill_dir}} is missing a {.field description} field.'
    )
  }
  invisible(meta)
}

# Read .skill-lock.json from a skills directory; returns a named list
read_lock <- function(path) {
  lf <- fs::path(path, lock_file)
  if (!fs::file_exists(lf)) {
    return(list())
  }
  jsonlite::read_json(lf)
}

# Write a named list to .skill-lock.json in a skills directory
write_lock <- function(path, lock) {
  fs::dir_create(path, recurse = TRUE)
  jsonlite::write_json(
    lock,
    fs::path(path, lock_file),
    auto_unbox = TRUE,
    pretty = TRUE
  )
  invisible(fs::path(path, lock_file))
}

# Download a skill from GitHub by owner/repo; returns path to extracted skill dir.
# If path is non-NULL, navigates into that subdirectory of the archive.
gh_download_skill <- function(owner, repo, path = NULL) {
  url <- paste0(
    'https://api.github.com/repos/', owner, '/', repo, '/zipball/HEAD'
  )
  tmp_zip <- fs::file_temp(ext = 'zip')
  tmp_dir <- fs::dir_create(fs::file_temp())

  resp <- httr2::request(url) |>
    httr2::req_headers(Accept = 'application/vnd.github+json') |>
    httr2::req_error(is_error = \(resp) FALSE) |>
    httr2::req_perform()

  if (httr2::resp_status(resp) >= 400) {
    cli::cli_abort(
      'Failed to download skill from GitHub ({owner}/{repo}): HTTP {httr2::resp_status(resp)}.'
    )
  }

  writeBin(httr2::resp_body_raw(resp), tmp_zip)
  utils::unzip(tmp_zip, exdir = tmp_dir)
  fs::file_delete(tmp_zip)

  # GitHub zipball has one top-level directory; find it
  top <- fs::dir_ls(tmp_dir, type = 'directory')
  if (length(top) != 1) {
    cli::cli_abort('Unexpected archive structure from GitHub download.')
  }
  skill_dir <- top[[1]]

  if (!is.null(path)) {
    skill_dir <- fs::path(skill_dir, path)
    if (!fs::dir_exists(skill_dir)) {
      cli::cli_abort(
        'Path {.path {path}} not found in {owner}/{repo}.'
      )
    }
  }

  skill_dir
}

# Get the latest commit SHA for owner/repo; returns a character string
gh_latest_sha <- function(owner, repo) {
  url <- paste0(
    'https://api.github.com/repos/', owner, '/', repo, '/commits/HEAD'
  )
  resp <- httr2::request(url) |>
    httr2::req_headers(Accept = 'application/vnd.github+json') |>
    httr2::req_error(is_error = \(resp) FALSE) |>
    httr2::req_perform()

  if (httr2::resp_status(resp) >= 400) {
    cli::cli_abort(
      'Failed to get latest SHA for {owner}/{repo}: HTTP {httr2::resp_status(resp)}.'
    )
  }

  httr2::resp_body_json(resp)$sha
}

# Search GitHub repositories; returns parsed JSON body as a list
gh_search_repos <- function(q, per_page = 30) {
  resp <- httr2::request('https://api.github.com/search/repositories') |>
    httr2::req_url_query(q = q, per_page = per_page) |>
    httr2::req_headers(Accept = 'application/vnd.github+json') |>
    httr2::req_error(is_error = \(resp) FALSE) |>
    httr2::req_perform()

  if (httr2::resp_status(resp) >= 400) {
    cli::cli_abort(
      'GitHub search failed with HTTP {httr2::resp_status(resp)}.'
    )
  }

  httr2::resp_body_json(resp)
}
