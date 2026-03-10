#' Remove an installed skill
#'
#' Deletes a skill directory from a skills directory and removes it from the
#' lock file.
#'
#' @param name The name of the skill to remove.
#' @param path The skills directory where the skill is installed. Can be one
#'   of:
#'   - A known agent name such as `"claude_code"`, `"cursor"`, or
#'     `"github_copilot"` (see [skill_path()] for the full list) to use that
#'     agent's conventional project-scope path.
#'   - A character string giving the directory path directly.
#'   - `NULL` (the default), in which case the path is resolved from the
#'     `WF_AGENT` environment variable, or by prompting in interactive
#'     sessions. Set `WF_AGENT` in your `.Renviron` (e.g. with
#'     [usethis::edit_r_environ()]) to avoid the prompt.
#' @param force If `FALSE` (the default), prompts for confirmation in
#'   interactive sessions. Set to `TRUE` to skip the prompt.
#'
#' @return The name of the removed skill, invisibly.
#' @export
#'
#' @examples
#' src <- tempfile()
#' dir.create(src)
#' writeLines(
#'   c('---', 'name: example', 'description: An example skill.', '---'),
#'   file.path(src, 'SKILL.md')
#' )
#' tmp <- tempfile()
#' add_skill(src, tmp)
#' remove_skill('example', tmp, force = TRUE)
remove_skill <- function(name, path = NULL, force = FALSE) {
  path <- resolve_path(path)
  skill_dir <- fs::path(path, name)
  if (!fs::dir_exists(skill_dir)) {
    cli::cli_abort(
      'Skill {.val {name}} is not installed at {.path {path}}.'
    )
  }

  if (!force && rlang::is_interactive()) {
    cli::cli_inform('Remove skill {.val {name}} from {.path {path}}? [y/N] ')
    answer <- readline()
    if (!tolower(trimws(answer)) %in% c('y', 'yes')) {
      cli::cli_inform('Removal cancelled.')
      return(invisible(name))
    }
  }

  fs::dir_delete(skill_dir)

  lock <- read_lock(path)
  lock[[name]] <- NULL
  write_lock(path, lock)

  cli::cli_inform('Removed skill {.val {name}} from {.path {path}}.')
  invisible(name)
}
