#' Update installed rules
#'
#' Checks each installed rule for available updates and re-installs any that
#' have a newer version on GitHub.
#'
#' @param path The rules directory to update. Can be one of:
#'   - A known coding agent name such as `"claude_code"`, `"cursor"`, or
#'     `"github_copilot"` (see [rule_path()] for the full list) to use that
#'     agent's conventional project-scope path.
#'   - A character string giving the directory path directly.
#'   - `NULL` (the default), in which case the path is resolved from the
#'     `WF_AGENT` environment variable, or by prompting in interactive
#'     sessions. Set `WF_AGENT` in your `.Renviron` (e.g. with
#'     [usethis::edit_r_environ()]) to avoid the prompt.
#'
#' @return A character vector of updated rule names, invisibly.
#' @export
#'
#' @examples
#' update_rules(tempfile())
update_rules <- function(path = NULL) {
  path <- resolve_rule_path(path)
  status <- check_rules(path)
  to_update <- status[status$update_available, 'name']

  if (length(to_update) == 0) {
    cli::cli_inform('All rules are up to date.')
    return(invisible(character()))
  }

  lock <- read_lock(path, rule_lock_file)
  for (name in to_update) {
    source <- lock[[name]]$source
    add_rule(source, path = path, overwrite = TRUE)
  }

  invisible(to_update)
}
