#' Update installed skills
#'
#' Checks each installed skill for available updates and re-installs any that
#' have a newer version on GitHub.
#'
#' @param path The skills directory to update. Defaults to [skill_path()],
#'   which resolves the agent from `WF_AGENT`, a directory scan, or falls
#'   back to `"claude_code"`.
#'
#' @return A character vector of updated skill names, invisibly.
#' @export
#'
#' @examples
#' update_skills(tempfile())
update_skills <- function(path = skill_path()) {
  status <- check_skills(path)
  to_update <- status[status$update_available, 'name']

  if (length(to_update) == 0) {
    cli::cli_inform('All skills are up to date.')
    return(invisible(character()))
  }

  lock <- read_lock(path)
  for (name in to_update) {
    source <- lock[[name]]$source
    add_skill(source, path, overwrite = TRUE)
  }

  invisible(to_update)
}
