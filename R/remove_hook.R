#' Remove an installed hook
#'
#' Deletes a hook script from the hooks directory, removes its registration
#' from `settings.json`, and removes it from the lock file.
#'
#' @param name The name of the hook to remove (the script filename stem,
#'   e.g. `"lint-staged"` for `lint-staged.sh`).
#' @param path `r roxy_path('hook', 'hook_path')`
#' @param settings Path to the `settings.json` file where the hook is
#'   registered. When `NULL` (the default), defaults to `settings.json` in
#'   the parent directory of `path`.
#' @param force `r roxy_force()`
#'
#' @return The name of the removed hook, invisibly.
#' @export
#'
#' @examples
#' tmp_hook <- tempfile(fileext = '.sh')
#' writeLines(c('#!/bin/bash', 'echo hello'), tmp_hook)
#' tmp_dir <- tempfile()
#' tmp_settings <- tempfile(fileext = '.json')
#' add_hook(tmp_hook,
#'   event = 'PreToolUse', path = tmp_dir,
#'   settings = tmp_settings
#' )
#' remove_hook(fs::path_ext_remove(basename(tmp_hook)), tmp_dir,
#'   settings = tmp_settings, force = TRUE
#' )
remove_hook <- function(name, path = NULL, settings = NULL, force = FALSE) {
  path <- resolve_hook_path(path)
  lock <- read_lock(path, hook_lock_section)

  if (is.null(lock[[name]])) {
    cli::cli_abort(
      c(
        'Hook {.val {name}} is not installed at {.path {path}}.',
        'i' = 'Use {.fun list_hooks} to see installed hooks.'
      )
    )
  }

  if (!force && rlang::is_interactive()) {
    cli::cli_inform('Remove hook {.val {name}} from {.path {path}}? [y/N] ')
    answer <- readline()
    if (!tolower(trimws(answer)) %in% c('y', 'yes')) {
      cli::cli_inform('Removal cancelled.')
      return(invisible(name))
    }
  }

  entry <- lock[[name]]

  # Delete the script file using the path recorded in the lock entry
  fpath <- entry$command
  if (!is.null(fpath) && fs::file_exists(fpath)) {
    fs::file_delete(fpath)
  }

  # Unregister from settings.json
  command <- entry$command
  event <- entry$event
  settings_path <- settings %||% default_settings_for_hook_dir(path)
  hook_settings <- read_settings(settings_path)

  if (
    !is.null(event) &&
      !is.null(hook_settings$hooks) &&
      !is.null(hook_settings$hooks[[event]])
  ) {
    groups <- hook_settings$hooks[[event]]
    new_groups <- list()
    for (group in groups) {
      filtered <- Filter(\(h) !identical(h$command, command), group$hooks)
      if (length(filtered) > 0) {
        group$hooks <- filtered
        new_groups <- c(new_groups, list(group))
      }
    }
    if (length(new_groups) == 0) {
      hook_settings$hooks[[event]] <- NULL
    } else {
      hook_settings$hooks[[event]] <- new_groups
    }
    write_settings(settings_path, hook_settings)
  }

  lock[[name]] <- NULL
  write_lock(path, lock, hook_lock_section)

  cli::cli_inform('Removed hook {.val {name}} from {.path {path}}.')
  invisible(name)
}
