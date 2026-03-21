#' Update installed hooks
#'
#' Checks each installed hook for available updates and re-installs any that
#' have a newer version on GitHub.
#'
#' @param path The hooks directory to update. Can be one of:
#'   - A known coding agent name such as `"claude_code"`, `"cursor"`, or
#'     `"github_copilot"` (see [hook_path()] for the full list) to use that
#'     agent's conventional project-scope path.
#'   - A character string giving the directory path directly.
#'   - `NULL` (the default), in which case the path is resolved from the
#'     `WF_AGENT` environment variable, or by prompting in interactive
#'     sessions. Set `WF_AGENT` in your `.Renviron` (e.g. with
#'     [usethis::edit_r_environ()]) to avoid the prompt.
#' @param settings Path to the `settings.json` file where hooks are
#'   registered. When `NULL` (the default), defaults to `settings.json` in
#'   the parent directory of `path`.
#'
#' @return A character vector of updated hook names, invisibly.
#' @export
#'
#' @examples
#' update_hooks(tempfile())
update_hooks <- function(path = NULL, settings = NULL) {
  path <- resolve_hook_path(path)
  status <- check_hooks(path)
  to_update <- status[status$update_available, 'name']

  if (length(to_update) == 0) {
    cli::cli_inform('All hooks are up to date.')
    return(invisible(character()))
  }

  lock <- read_lock(path, hook_lock_section)
  for (name in to_update) {
    entry <- lock[[name]]
    add_hook(
      source = entry$source,
      event = entry$event,
      path = path,
      settings = settings,
      overwrite = TRUE
    )
  }

  invisible(to_update)
}
