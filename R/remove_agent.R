#' Remove an installed agent
#'
#' Deletes an agent file from an agents directory and removes it from the
#' lock file.
#'
#' @param name The name of the agent to remove (without the `.md` extension).
#' @param path The agents directory where the agent is installed. Can be one
#'   of:
#'   - A known coding agent name such as `"claude_code"`, `"cursor"`, or
#'     `"github_copilot"` (see [agent_path()] for the full list) to use that
#'     agent's conventional project-scope path.
#'   - A character string giving the directory path directly.
#'   - `NULL` (the default), in which case the path is resolved from the
#'     `WF_AGENT` environment variable, or by prompting in interactive
#'     sessions. Set `WF_AGENT` in your `.Renviron` (e.g. with
#'     [usethis::edit_r_environ()]) to avoid the prompt.
#' @param force If `FALSE` (the default), prompts for confirmation in
#'   interactive sessions. Set to `TRUE` to skip the prompt.
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

  lock <- read_lock(path, agent_lock_file)
  lock[[name]] <- NULL
  write_lock(path, lock, agent_lock_file)

  cli::cli_inform('Removed agent {.val {name}} from {.path {path}}.')
  invisible(name)
}
