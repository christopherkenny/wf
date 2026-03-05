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
#' @param path The skills directory to install into. Defaults to
#'   [skill_path()], which resolves the agent from `WF_AGENT`, a directory
#'   scan, or falls back to `"claude_code"`.
#' @param skill For multi-skill repositories that store skills under a
#'   `skills/` subdirectory, the name of the skill to install, e.g.
#'   `skill = "proofread"`. When supplied, the skill is read from
#'   `skills/<skill>` within the repository. Ignored when `source` already
#'   points to a specific subdirectory via `/tree/...`.
#' @param overwrite If `FALSE` (the default), an error is raised if the skill
#'   is already installed. Set to `TRUE` to replace it.
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
#' add_skill(src, tempfile())
add_skill <- function(source, path = skill_path(), skill = NULL, overwrite = FALSE) {
  type <- parse_source(source)
  if (type == 'github') {
    gh <- parse_gh_source(source)
    if (!is.null(skill) && is.null(gh$path)) {
      gh$path <- paste0('skills/', skill)
    }
    skill_dir <- gh_download_skill(gh$owner, gh$repo, gh$path)
    sha <- gh_latest_sha(gh$owner, gh$repo)
    lock_source <- if (is.null(gh$path)) {
      paste0('https://github.com/', gh$owner, '/', gh$repo)
    } else {
      paste0(
        'https://github.com/', gh$owner, '/', gh$repo,
        '/tree/HEAD/', gh$path
      )
    }
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

  lock <- read_lock(path)
  entry <- list(
    source = lock_source,
    type = type,
    installed_at = format(Sys.time(), '%Y-%m-%dT%H:%M:%SZ', tz = 'UTC')
  )
  if (!is.null(sha)) entry$sha <- sha
  lock[[name]] <- entry
  write_lock(path, lock)

  cli::cli_inform('Installed skill {.val {name}} to {.path {dest}}.')
  invisible(dest)
}
