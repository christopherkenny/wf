#' Create a new hook template
#'
#' Creates a new shell script hook file at `path/name.sh` containing a
#' minimal template ready to be filled in. After editing the script,
#' register it with [register_hook()] or install it with [add_hook()].
#'
#' @param name Hook name. Must be 1-64 characters, lowercase alphanumeric
#'   with single hyphens (no consecutive `--`), and cannot start or end
#'   with a hyphen. Consider using a kebab-case verb form (e.g.
#'   `"lint-on-save"`, `"check-format"`).
#' @param path Directory in which to create the hook file. Can be one of:
#'   - A known coding agent name such as `"claude_code"` or
#'     `"github_copilot"` to use that agent's conventional project-scope
#'     path (see [hook_path()] for the full list).
#'   - A character string giving the directory path directly.
#'   - `NULL` (the default), in which case the path is resolved from the
#'     `WF_AGENT` environment variable, or by prompting in interactive
#'     sessions. Set `WF_AGENT` in your `.Renviron` (e.g. with
#'     [usethis::edit_r_environ()]) to avoid the prompt.
#'
#' @return The path to the new hook file, invisibly.
#' @export
#'
#' @examples
#' init_hook('my-hook', tempfile())
init_hook <- function(name, path = NULL) {
  check_item_name(name)
  path <- resolve_hook_path(path)
  hook_file <- fs::path(path, paste0(name, '.sh'))
  if (fs::file_exists(hook_file)) {
    cli::cli_abort('Hook file {.path {hook_file}} already exists.')
  }
  fs::dir_create(path, recurse = TRUE)
  writeLines(
    c(
      '#!/bin/bash',
      paste0('# Hook: ', name),
      '# Description: TODO',
      '',
      '# Read JSON input from stdin',
      'input=$(cat)',
      '',
      '# Add your hook logic here',
      'echo "$input"'
    ),
    hook_file
  )
  cli::cli_inform(
    c(
      'Created hook {.val {name}} at {.path {hook_file}}.',
      'i' = 'Register it with {.run register_hook(event, command = {.val {as.character(hook_file)}})}'
    )
  )
  invisible(hook_file)
}
