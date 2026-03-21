#' Check installed agents for available updates
#'
#' Compares each installed agent's recorded commit SHA against the latest
#' commit on GitHub. Local agents are reported as not updatable.
#'
#' @param path `r roxy_path('agent', 'agent_path')`
#'
#' @return `r roxy_check_cols('agent')`
#' @export
#'
#' @examples
#' check_agents(tempfile())
check_agents <- function(path = NULL) {
  path <- resolve_agent_path(path)
  check_lock_items(read_lock(path, agent_lock_section))
}
