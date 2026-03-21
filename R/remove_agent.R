#' Remove an installed agent
#'
#' Deletes an agent file from an agents directory and removes it from the
#' lock file.
#'
#' @param name The name of the agent to remove (without the `.md` extension).
#' @param path `r roxy_path('agent', 'agent_path')`
#' @param force `r roxy_force()`
#'
#' @return The name of the removed agent, invisibly.
#' @export
#'
#' @examples
#' src <- tempfile(fileext = '.md')
#' writeLines(
#'   c('---', 'name: example', 'description: An example agent.', '---'),
#'   src
#' )
#' tmp <- tempfile()
#' add_agent(src, path = tmp)
#' remove_agent('example', tmp, force = TRUE)
remove_agent <- function(name, path = NULL, force = FALSE) {
  path <- resolve_agent_path(path)
  agent_file <- fs::path(path, paste0(name, '.md'))
  if (!fs::file_exists(agent_file)) {
    cli::cli_abort(
      'Agent {.val {name}} is not installed at {.path {path}}.'
    )
  }

  if (!force && rlang::is_interactive()) {
    cli::cli_inform('Remove agent {.val {name}} from {.path {path}}? [y/N] ')
    answer <- readline()
    if (!tolower(trimws(answer)) %in% c('y', 'yes')) {
      cli::cli_inform('Removal cancelled.')
      return(invisible(name))
    }
  }

  fs::file_delete(agent_file)

  lock <- read_lock(path, agent_lock_section)
  lock[[name]] <- NULL
  write_lock(path, lock, agent_lock_section)

  cli::cli_inform('Removed agent {.val {name}} from {.path {path}}.')
  invisible(name)
}
