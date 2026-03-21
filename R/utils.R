agent_aliases <- list(
  claude = 'claude_code',
  copilot = 'github_copilot',
  posit = 'posit_ai'
)

agent_indicators <- c(
  claude_code = '.claude',
  openclaw = '.openclaw',
  codex = '.codex',
  cursor = '.cursor',
  gemini_cli = '.gemini',
  github_copilot = '.copilot',
  posit_ai = '.positai'
)

detect_agent <- function() {
  found <- names(agent_indicators)[fs::dir_exists(agent_indicators)]
  if (length(found) == 0) {
    return(NULL)
  }
  found[[1]]
}

# Resolve a `path` argument to a concrete directory path.
# - If path is a known agent name (or alias), returns the project-scope path.
# - If path is NULL, checks WF_AGENT, then prompts interactively, then aborts.
# - Otherwise returns path unchanged.
resolve_path <- function(path, paths, type) {
  if (!is.null(path)) {
    agent_norm <- agent_aliases[[path]] %||% path
    if (agent_norm %in% names(paths)) {
      return(paths[[agent_norm]][['project']])
    }
    return(path)
  }

  env_agent <- Sys.getenv('WF_AGENT', unset = '')
  if (nzchar(env_agent)) {
    agent_norm <- agent_aliases[[env_agent]] %||% env_agent
    if (!agent_norm %in% names(paths)) {
      cli::cli_abort(
        c(
          '{.envvar WF_AGENT} is set to {.val {env_agent}}, which is not a known agent.',
          'i' = 'Set {.envvar WF_AGENT} to one of {.or {.val {names(paths)}}}.',
          'i' = 'Use {.run usethis::edit_r_environ()} to open {.file .Renviron}.'
        )
      )
    }
    return(paths[[agent_norm]][['project']])
  }

  if (rlang::is_interactive()) {
    found <- names(agent_indicators)[fs::dir_exists(agent_indicators)]
    found <- found[found %in% names(paths)]
    n <- length(found)
    if (n > 0) {
      items <- c(
        paste0(seq_len(n), '. ', agent_indicators[found], ' (', found, ')'),
        paste0(n + 1L, '. None of these')
      )
      cli::cli_inform(
        c(
          '!' = 'No {.arg path} set. Detected agent director{?y/ies}:',
          stats::setNames(items, rep(' ', n + 1L))
        )
      )
      answer <- readline('Enter selection: ')
      idx <- suppressWarnings(as.integer(trimws(answer)))
      if (!is.na(idx) && idx >= 1L && idx <= n) {
        return(paths[[found[[idx]]]][['project']])
      }
    }
  }

  cli::cli_abort(
    c(
      'Cannot determine a {type} directory.',
      'i' = 'Set {.envvar WF_AGENT} to one of {.or {.val {names(paths)}}}.',
      'i' = 'Use {.run usethis::edit_r_environ()} to open {.file .Renviron}.',
      'i' = 'Or supply {.arg path} directly.'
    )
  )
}

# Classify a source as "github" or "local"
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
#   "https://github.com/owner/repo/tree/branch/path/to/item"
parse_gh_source <- function(source) {
  source <- sub('\\.git$', '', source)
  if (grepl('^https?://github\\.com/', source)) {
    parts <- strsplit(sub('^https?://github\\.com/', '', source), '/')[[1]]
    owner <- parts[[1]]
    repo <- parts[[2]]
    # /tree/{branch}/{path...} -> extract path
    if (length(parts) >= 5 && parts[[3]] == 'tree') {
      path <- paste(parts[5:length(parts)], collapse = '/')
    } else if (length(parts) > 2) {
      path <- paste(parts[3:length(parts)], collapse = '/')
    } else {
      path <- NULL
    }
    list(owner = owner, repo = repo, path = path)
  } else {
    parts <- strsplit(source, '/')[[1]]
    list(owner = parts[[1]], repo = parts[[2]], path = NULL)
  }
}

# Read a section from the unified lock file; returns a named list
read_lock <- function(path, section) {
  lf <- fs::path(fs::path_dir(path), '.wf-lock.json')
  if (!fs::file_exists(lf)) {
    return(list())
  }
  jsonlite::read_json(lf)[[section]] %||% list()
}

# Write a section to the unified lock file
write_lock <- function(path, lock, section) {
  root <- fs::path_dir(path)
  lf <- fs::path(root, '.wf-lock.json')
  full <- if (fs::file_exists(lf)) jsonlite::read_json(lf) else list()
  full[[section]] <- lock
  fs::dir_create(root, recurse = TRUE)
  jsonlite::write_json(full, lf, auto_unbox = TRUE, pretty = TRUE)
  invisible(lf)
}

# Migrate legacy per-type lock files into the unified .wf-lock.json
migrate_lock <- function(path) {
  old_files <- list(
    skills = fs::path(path, 'skills', '.skill-lock.json'),
    agents = fs::path(path, 'agents', '.agent-lock.json'),
    hooks = fs::path(path, 'hooks', '.hook-lock.json'),
    rules = fs::path(path, 'rules', '.rule-lock.json')
  )

  migrated <- character()
  for (section in names(old_files)) {
    old_file <- old_files[[section]]
    if (!fs::file_exists(old_file)) {
      next
    }
    entries <- jsonlite::read_json(old_file)
    if (length(entries) == 0) {
      next
    }
    write_lock(fs::path(path, section), entries, section)
    migrated <- c(migrated, section)
    cli::cli_inform(c(
      'Migrated {length(entries)} {section} entr{?y/ies} from {.path {old_file}}.',
      'i' = 'You can safely delete {.path {old_file}}.'
    ))
  }

  if (length(migrated) == 0) {
    cli::cli_inform('No legacy lock files found.')
  }

  invisible(migrated)
}

# Download a repo from GitHub; returns path to the extracted root directory.
gh_download <- function(owner, repo) {
  tmp_zip <- fs::file_temp(ext = 'zip')
  tmp_dir <- fs::dir_create(fs::file_temp())

  gh::gh(
    '/repos/{owner}/{repo}/zipball/HEAD',
    owner = owner,
    repo = repo,
    .destfile = tmp_zip,
    .overwrite = TRUE
  )

  utils::unzip(tmp_zip, exdir = tmp_dir)
  fs::file_delete(tmp_zip)

  top <- fs::dir_ls(tmp_dir, type = 'directory')
  if (length(top) != 1) {
    cli::cli_abort('Unexpected archive structure from GitHub download.')
  }
  top[[1]]
}

# Get the latest commit SHA for owner/repo; returns a character string
gh_latest_sha <- function(owner, repo) {
  resp <- gh::gh(
    '/repos/{owner}/{repo}/commits/HEAD',
    owner = owner,
    repo = repo
  )
  resp$sha
}

# Search GitHub repositories; returns parsed JSON body as a list
gh_search_repos <- function(q, per_page = 30) {
  gh::gh('/search/repositories', q = q, per_page = per_page)
}

check_item_name <- function(name) {
  if (!is.character(name) || length(name) != 1 || is.na(name)) {
    cli::cli_abort('{.arg name} must be a single non-missing string.')
  }
  if (nchar(name) == 0 || nchar(name) > 64) {
    cli::cli_abort(
      '{.arg name} must be between 1 and 64 characters, not {nchar(name)}.'
    )
  }
  if (!grepl('^[a-z0-9]([a-z0-9-]*[a-z0-9])?$', name)) {
    cli::cli_abort(
      c(
        '{.arg name} must be lowercase alphanumeric with hyphens.',
        'i' = 'It cannot start or end with a hyphen.',
        'x' = 'Got {.val {name}}.'
      )
    )
  }
  if (grepl('--', name)) {
    cli::cli_abort(
      c(
        '{.arg name} cannot contain consecutive hyphens.',
        'x' = 'Got {.val {name}}.'
      )
    )
  }
  invisible(name)
}

# Shared helper for agent_path / hook_path / rule_path / skill_path
get_scope_path <- function(agent, scope, paths, call = rlang::caller_env()) {
  agent <- agent %||% Sys.getenv('WF_AGENT', unset = '')
  if (!nzchar(agent)) {
    agent <- detect_agent() %||% 'claude_code'
  }
  agent <- agent_aliases[[agent]] %||% agent
  agents <- names(paths)
  if (!agent %in% agents) {
    cli::cli_abort(
      c(
        '{.arg agent} must be one of {.or {.val {agents}}}.',
        'x' = 'Got {.val {agent}}.'
      ),
      call = call
    )
  }
  paths[[agent]][[scope]]
}

# Shared helper for find_agent / find_hook / find_rule / find_skill
find_gh_items <- function(query, topics, call = rlang::caller_env()) {
  rlang::check_required(query, call = call)
  if (!nzchar(query)) {
    cli::cli_abort('{.arg query} must not be empty.', call = call)
  }
  items <- list()
  seen <- character()
  for (topic in topics) {
    q <- paste(query, paste0('topic:', topic))
    new_items <- gh_search_repos(q)$items
    for (item in new_items) {
      if (!item$html_url %in% seen) {
        seen <- c(seen, item$html_url)
        items <- c(items, list(item))
      }
    }
  }
  if (length(items) == 0) {
    return(data.frame(
      name = character(),
      description = character(),
      owner = character(),
      url = character(),
      stars = integer(),
      stringsAsFactors = FALSE
    ))
  }
  data.frame(
    name = vapply(items, `[[`, character(1), 'name'),
    description = vapply(
      items,
      function(x) x$description %||% NA_character_,
      character(1)
    ),
    owner = vapply(items, function(x) x$owner$login, character(1)),
    url = vapply(items, `[[`, character(1), 'html_url'),
    stars = vapply(items, `[[`, integer(1), 'stargazers_count'),
    stringsAsFactors = FALSE
  )
}

# Shared helper for check_agents / check_hooks / check_rules / check_skills
check_lock_items <- function(lock) {
  if (length(lock) == 0) {
    return(data.frame(
      name = character(),
      installed_sha = character(),
      latest_sha = character(),
      update_available = logical(),
      stringsAsFactors = FALSE
    ))
  }
  rows <- lapply(names(lock), function(name) {
    entry <- lock[[name]]
    sha_val <- entry$sha
    installed_sha <- NA_character_
    if (!is.null(sha_val) && length(sha_val) > 0 && is.character(sha_val)) {
      installed_sha <- sha_val
    }
    if (identical(entry$type, 'github') && !is.null(entry$source)) {
      gh <- parse_gh_source(entry$source)
      latest_sha <- tryCatch(
        gh_latest_sha(gh$owner, gh$repo),
        error = function(e) {
          cli::cli_warn(
            'Could not fetch latest SHA for {.val {name}}: {conditionMessage(e)}'
          )
          NA_character_
        }
      )
    } else {
      latest_sha <- NA_character_
    }
    data.frame(
      name = name,
      installed_sha = installed_sha,
      latest_sha = latest_sha,
      update_available = !is.na(installed_sha) &&
        !is.na(latest_sha) &&
        !identical(installed_sha, latest_sha),
      stringsAsFactors = FALSE
    )
  })
  do.call(rbind, rows)
}

# Build a GitHub lock source URL from a parsed gh source list
make_gh_lock_source <- function(gh) {
  if (is.null(gh$path)) {
    paste0('https://github.com/', gh$owner, '/', gh$repo)
  } else {
    paste0(
      'https://github.com/', gh$owner, '/', gh$repo,
      '/tree/HEAD/', gh$path
    )
  }
}

# Read YAML frontmatter from a markdown file; returns a named list
read_md_meta <- function(file) {
  if (!fs::file_exists(file)) {
    cli::cli_abort('No file found at {.path {file}}.')
  }
  lines <- readLines(file, warn = FALSE)
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
