#' List hooks in a settings file
#'
#' Returns a data frame of all hooks configured in a coding agent's
#' `settings.json` file.
#'
#' @param path The hooks directory. When supplied, the `file` column in the
#'   returned data frame will contain the path to the installed script file
#'   for hooks that were installed with [add_hook()]. Can be one of:
#'   - A known coding agent name to use that agent's conventional hooks path.
#'   - A character string giving the directory path directly.
#'   - `NULL` (the default), in which case `file` will be `NA` for all rows.
#' @param settings Path to the `settings.json` file to read. When `NULL`
#'   (the default), resolved from `agent`, `scope`, and the `WF_AGENT`
#'   environment variable.
#' @param agent,scope Passed to [settings_path()] to locate the settings
#'   file when `settings` is `NULL`. Defaults resolve to the project-scope
#'   settings of the detected coding agent.
#'
#' @return A data frame with columns:
#'   - `event`: the lifecycle event name (e.g. `"PreToolUse"`).
#'   - `matcher`: the tool-name pattern, or `NA` if none.
#'   - `command`: the shell command to execute.
#'   - `file`: path to the installed script file, or `NA` if not tracked.
#' @export
#'
#' @examples
#' tmp <- tempfile(fileext = '.json')
#' register_hook('PreToolUse', 'echo hello', path = tmp)
#' list_hooks(settings = tmp)
list_hooks <- function(
  path = NULL,
  settings = NULL,
  agent = NULL,
  scope = c('project', 'local', 'global')
) {
  scope <- rlang::arg_match(scope)
  settings_path <- settings %||% resolve_hook_settings_path(NULL, agent, scope)
  hook_settings <- read_settings(settings_path)

  # Build set of tracked command paths from lock file if path is provided
  tracked_commands <- character()
  if (!is.null(path)) {
    hook_dir <- resolve_hook_path(path)
    lock <- read_lock(hook_dir, hook_lock_section)
    tracked_commands <- vapply(lock, `[[`, character(1), 'command')
  }

  empty <- data.frame(
    event = character(),
    matcher = character(),
    command = character(),
    file = character(),
    stringsAsFactors = FALSE
  )

  hooks <- hook_settings$hooks
  if (length(hooks) == 0) {
    return(empty)
  }

  rows <- list()
  for (event in names(hooks)) {
    for (group in hooks[[event]]) {
      matcher_val <- group$matcher %||% NA_character_
      for (h in group$hooks) {
        cmd <- h$command %||% NA_character_
        file_val <- NA_character_
        if (!is.na(cmd) && cmd %in% tracked_commands) {
          file_val <- cmd
        }
        rows <- c(rows, list(data.frame(
          event = event,
          matcher = as.character(matcher_val),
          command = cmd,
          file = file_val,
          stringsAsFactors = FALSE
        )))
      }
    }
  }

  if (length(rows) == 0) {
    return(empty)
  }
  do.call(rbind, rows)
}
