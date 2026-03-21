#' Install a skill
#'
#' Installs a skill from a GitHub repository or a local directory into a skills
#' directory.
#'
#' @param source One of:
#'   - A GitHub URL pointing to a repo, e.g. `"https://github.com/owner/repo"`.
#'   - A GitHub URL pointing to a subdirectory, e.g.
#'     `"https://github.com/owner/repo/tree/main/path/to/skill"`.
#'   - A GitHub shorthand, e.g. `"owner/repo"`.
#'   - A local directory path containing a `SKILL.md` file.
#' @param skill For multi-skill repositories that store skills under a
#'   `skills/` subdirectory, the name of the skill to install, e.g.
#'   `skill = "proofread"`. When supplied, the skill is read from
#'   `skills/<skill>` within the repository. Ignored when `source` already
#'   points to a specific subdirectory via `/tree/...`.
#' @param path `r roxy_path('skill', 'skill_path')`
#' @param overwrite `r roxy_overwrite('skill')`
#'
#' @return The path to the installed skill directory, invisibly.
#' @export
#'
#' @examples
#' src <- tempfile()
#' dir.create(src)
#' writeLines(
#'   c('---', 'name: example', 'description: An example skill.', '---'),
#'   file.path(src, 'SKILL.md')
#' )
#' add_skill(src, path = tempfile())
add_skill <- function(source, skill = NULL, path = NULL, overwrite = FALSE) {
  path <- resolve_skill_path(path)
  type <- parse_source(source)
  if (type == 'github') {
    gh <- parse_gh_source(source)
    if (!is.null(skill) && is.null(gh$path)) {
      gh$path <- paste0('skills/', skill)
    }
    repo_root <- gh_download(gh$owner, gh$repo)
    skill_dir <- if (!is.null(gh$path)) {
      inner <- fs::path(repo_root, gh$path)
      if (!fs::dir_exists(inner)) {
        cli::cli_abort('Path {.path {gh$path}} not found in {gh$owner}/{gh$repo}.')
      }
      inner
    } else {
      repo_root
    }
    sha <- gh_latest_sha(gh$owner, gh$repo)
    lock_source <- make_gh_lock_source(gh)
  } else {
    skill_dir <- source
    if (!fs::dir_exists(skill_dir)) {
      cli::cli_abort('Local skill source {.path {skill_dir}} does not exist.')
    }
    sha <- NULL
    lock_source <- fs::path_abs(skill_dir)
  }

  meta <- validate_skill_dir(skill_dir)
  name <- meta$name
  dest <- fs::path(path, name)

  if (fs::dir_exists(dest)) {
    if (!overwrite) {
      cli::cli_abort(
        c(
          'Skill {.val {name}} is already installed at {.path {dest}}.',
          'i' = 'Use {.code overwrite = TRUE} to replace it.'
        )
      )
    }
    fs::dir_delete(dest)
  }

  fs::dir_create(path, recurse = TRUE)
  fs::dir_copy(skill_dir, dest)

  lock <- read_lock(path, skill_lock_section)
  entry <- list(
    source = lock_source,
    type = type,
    installed_at = format(Sys.time(), '%Y-%m-%dT%H:%M:%SZ', tz = 'UTC')
  )
  if (!is.null(sha)) {
    entry$sha <- sha
  }
  lock[[name]] <- entry
  write_lock(path, lock, skill_lock_section)

  cli::cli_inform('Installed skill {.val {name}} to {.path {dest}}.')
  invisible(dest)
}
