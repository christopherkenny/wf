#' Register a hook command in the settings file
#'
#' Adds a shell command hook to a coding agent's `settings.json` file. Hooks
#' run automatically on agent events such as `"PreToolUse"` or
#' `"UserPromptSubmit"`. To install a hook script from GitHub or a local
#' file, use [add_hook()] instead.
#'
#' @param event The lifecycle event to attach the hook to. One of
#'   `"PreToolUse"`, `"PostToolUse"`, `"UserPromptSubmit"`, `"Stop"`, or
#'   `"SubagentStop"`.
#' @param command The shell command to execute when the hook fires.
#' @param matcher An optional tool-name pattern (for `"PreToolUse"` and
#'   `"PostToolUse"` events) used to filter which tool calls trigger the
#'   hook, e.g. `"Bash|Edit"`. When `NULL` (the default), the hook applies
#'   to all tool calls for the event.
#' @param timeout Optional timeout in seconds for the hook command.
#' @param async If `TRUE`, the hook runs asynchronously and the agent does
#'   not wait for it to complete. Default is `FALSE`.
#' @param agent,scope,path Passed to [settings_path()] to locate the
#'   settings file. Defaults resolve to the project-scope settings of the
#'   detected coding agent.
#'
#' @return The path to the modified settings file, invisibly.
#' @export
#'
#' @examples
#' tmp <- tempfile(fileext = '.json')
#' register_hook('PreToolUse', 'echo hello', path = tmp)
register_hook <- function(
  event,
  command,
  matcher = NULL,
  timeout = NULL,
  async = FALSE,
  agent = NULL,
  scope = c('project', 'local', 'global'),
  path = NULL
) {
  event <- rlang::arg_match(event, hook_events)
  scope <- rlang::arg_match(scope)
  settings_path <- resolve_hook_settings_path(path, agent, scope)
  settings <- read_settings(settings_path)

  if (is.null(settings$hooks)) {
    settings$hooks <- list()
  }
  if (is.null(settings$hooks[[event]])) {
    settings$hooks[[event]] <- list()
  }

  hook_entry <- list(type = 'command', command = command)
  if (!is.null(timeout)) {
    hook_entry$timeout <- timeout
  }
  if (isTRUE(async)) {
    hook_entry$async <- TRUE
  }

  existing <- settings$hooks[[event]]
  matcher_str <- matcher %||% ''
  group_idx <- NA_integer_
  for (i in seq_along(existing)) {
    grp_matcher <- existing[[i]]$matcher %||% ''
    if (identical(grp_matcher, matcher_str)) {
      group_idx <- i
      break
    }
  }

  if (is.na(group_idx)) {
    new_group <- list(hooks = list(hook_entry))
    if (!is.null(matcher)) {
      new_group$matcher <- matcher
    }
    settings$hooks[[event]] <- c(existing, list(new_group))
  } else {
    settings$hooks[[event]][[group_idx]]$hooks <- c(
      settings$hooks[[event]][[group_idx]]$hooks,
      list(hook_entry)
    )
  }

  write_settings(settings_path, settings)
  cli::cli_inform(
    'Registered {.field {event}} hook in {.path {settings_path}}.'
  )
  invisible(settings_path)
}
