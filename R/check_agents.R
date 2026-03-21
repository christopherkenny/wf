#' Check installed agents for available updates
#'
#' Compares each installed agent's recorded commit SHA against the latest
#' commit on GitHub. Local agents are reported as not updatable.
#'
#' @param path The agents directory to check. Can be one of:
#'   - A known coding agent name such as `"claude_code"`, `"cursor"`, or
#'     `"github_copilot"` (see [agent_path()] for the full list) to use that
#'     agent's conventional project-scope path.
#'   - A character string giving the directory path directly.
#'   - `NULL` (the default), in which case the path is resolved from the
#'     `WF_AGENT` environment variable, or by prompting in interactive
#'     sessions. Set `WF_AGENT` in your `.Renviron` (e.g. with
#'     [usethis::edit_r_environ()]) to avoid the prompt.
#'
#' @return A data frame with columns:
#'   - `name`: agent name.
#'   - `installed_sha`: the SHA recorded at install time (`NA` for local).
#'   - `latest_sha`: the current HEAD SHA on GitHub (`NA` for local or on
#'     network failure).
#'   - `update_available`: `TRUE` if installed and latest SHAs differ.
#' @export
#'
#' @examples
#' check_agents(tempfile())
check_agents <- function(path = NULL) {
  path <- resolve_agent_path(path)
  check_lock_items(read_lock(path, agent_lock_file))
}
