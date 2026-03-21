#' Create a new rule template
#'
#' Creates a new rule file at `path/name.md` containing a template ready to
#' be filled in.
#'
#' @param name Rule name. Must be 1-64 characters, lowercase alphanumeric
#'   with single hyphens (no consecutive `--`), and cannot start or end with
#'   a hyphen. Consider a descriptive noun form (e.g. `"testing"`,
#'   `"code-style"`).
#' @param path Directory in which to create the rule file. Can be one of:
#'   - A known coding agent name such as `"claude_code"` or `"github_copilot"`
#'     to use that agent's conventional project-scope path (see [rule_path()]
#'     for the full list).
#'   - A character string giving the directory path directly.
#'   - `NULL` (the default), in which case the path is resolved from the
#'     `WF_AGENT` environment variable, or by prompting in interactive
#'     sessions. Set `WF_AGENT` in your `.Renviron` (e.g. with
#'     [usethis::edit_r_environ()]) to avoid the prompt.
#'
#' @return The path to the new rule file, invisibly.
#' @export
#'
#' @examples
#' init_rule('my-rule', tempfile())
init_rule <- function(name, path = NULL) {
  check_item_name(name)
  path <- resolve_rule_path(path)
  rule_file <- fs::path(path, paste0(name, '.md'))
  if (fs::file_exists(rule_file)) {
    cli::cli_abort(
      'Rule file {.path {rule_file}} already exists.'
    )
  }
  fs::dir_create(path, recurse = TRUE)
  title <- paste0(
    toupper(substring(name, 1, 1)),
    gsub('-', ' ', substring(name, 2))
  )
  writeLines(
    c(
      '---',
      paste0('name: ', name),
      'description: >',
      '  What this rule covers and when it applies.',
      '---',
      '',
      paste0('# ', title),
      '',
      'Add your rule instructions here.'
    ),
    rule_file
  )
  cli::cli_inform('Created rule {.val {name}} at {.path {rule_file}}.')
  invisible(rule_file)
}
