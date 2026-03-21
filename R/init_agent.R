#' Create a new agent template
#'
#' Creates a new agent file at `path/name.md` containing a template ready to
#' be filled in.
#'
#' @param name Agent name. Must be 1-64 characters, lowercase alphanumeric
#'   with single hyphens (no consecutive `--`), and cannot start or end with
#'   a hyphen. Consider using a gerund or role form (e.g.
#'   `"code-reviewer"`, `"test-writer"`).
#' @param path Directory in which to create the agent file. Can be one of:
#'   - A known coding agent name such as `"claude_code"` or `"github_copilot"`
#'     to use that agent's conventional project-scope path (see [agent_path()]
#'     for the full list).
#'   - A character string giving the directory path directly.
#'   - `NULL` (the default), in which case the path is resolved from the
#'     `WF_AGENT` environment variable, or by prompting in interactive
#'     sessions. Set `WF_AGENT` in your `.Renviron` (e.g. with
#'     [usethis::edit_r_environ()]) to avoid the prompt.
#'
#' @return The path to the new agent file, invisibly.
#' @export
#'
#' @examples
#' init_agent('my-agent', tempfile())
init_agent <- function(name, path = NULL) {
  check_item_name(name)
  path <- resolve_agent_path(path)
  agent_file <- fs::path(path, paste0(name, '.md'))
  if (fs::file_exists(agent_file)) {
    cli::cli_abort(
      'Agent file {.path {agent_file}} already exists.'
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
      '  What this agent does and when to use it.',
      'tools: Read, Grep, Glob, Bash',
      'model: sonnet',
      '---',
      '',
      paste0('# ', title),
      '',
      'Add your agent system prompt here.'
    ),
    agent_file
  )
  cli::cli_inform('Created agent {.val {name}} at {.path {agent_file}}.')
  invisible(agent_file)
}
