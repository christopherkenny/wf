#' Remove an installed skill
#'
#' Deletes a skill directory from a skills directory and removes it from the
#' lock file.
#'
#' @param name The name of the skill to remove.
#' @param path `r roxy_path('skill', 'skill_path')`
#' @param force `r roxy_force()`
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
#' add_skill(src, path = tmp)
#' remove_skill('example', tmp, force = TRUE)
remove_skill <- function(name, path = NULL, force = FALSE) {
  path <- resolve_skill_path(path)
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

  lock <- read_lock(path, skill_lock_section)
  lock[[name]] <- NULL
  write_lock(path, lock, skill_lock_section)

  cli::cli_inform('Removed skill {.val {name}} from {.path {path}}.')
  invisible(name)
}
