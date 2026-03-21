#' Update installed agents
#'
#' Checks each installed agent for available updates and re-installs any that
#' have a newer version on GitHub.
#'
#' @param path The agents directory to update. Can be one of:
#'   - A known coding agent name such as `"claude_code"`, `"cursor"`, or
#'     `"github_copilot"` (see [agent_path()] for the full list) to use that
#'     agent's conventional project-scope path.
#'   - A character string giving the directory path directly.
#'   - `NULL` (the default), in which case the path is resolved from the
#'     `WF_AGENT` environment variable, or by prompting in interactive
#'     sessions. Set `WF_AGENT` in your `.Renviron` (e.g. with
#'     [usethis::edit_r_environ()]) to avoid the prompt.
#'
#' @return A character vector of updated agent names, invisibly.
#' @export
#'
#' @examples
#' update_agents(tempfile())
update_agents <- function(path = NULL) {
  path <- resolve_agent_path(path)
  status <- check_agents(path)
  to_update <- status[status$update_available, 'name']

  if (length(to_update) == 0) {
    cli::cli_inform('All agents are up to date.')
    return(invisible(character()))
  }

  lock <- read_lock(path, agent_lock_file)
  for (name in to_update) {
    source <- lock[[name]]$source
    add_agent(source, path = path, overwrite = TRUE)
  }

  invisible(to_update)
}
