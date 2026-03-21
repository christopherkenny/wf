#' Update installed skills
#'
#' Checks each installed skill for available updates and re-installs any that
#' have a newer version on GitHub.
#'
#' @param path The skills directory to update. Can be one of:
#'   - A known agent name such as `"claude_code"`, `"cursor"`, or
#'     `"github_copilot"` (see [skill_path()] for the full list) to use that
#'     agent's conventional project-scope path.
#'   - A character string giving the directory path directly.
#'   - `NULL` (the default), in which case the path is resolved from the
#'     `WF_AGENT` environment variable, or by prompting in interactive
#'     sessions. Set `WF_AGENT` in your `.Renviron` (e.g. with
#'     [usethis::edit_r_environ()]) to avoid the prompt.
#'
#' @return A character vector of updated skill names, invisibly.
#' @export
#'
#' @examples
#' update_skills(tempfile())
update_skills <- function(path = NULL) {
  path <- resolve_skill_path(path)
  status <- check_skills(path)
  to_update <- status[status$update_available, 'name']

  if (length(to_update) == 0) {
    cli::cli_inform('All skills are up to date.')
    return(invisible(character()))
  }

  lock <- read_lock(path, skill_lock_file)
  for (name in to_update) {
    source <- lock[[name]]$source
    add_skill(source, path = path, overwrite = TRUE)
  }

  invisible(to_update)
}
