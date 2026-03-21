#' Get the conventional agent path for a coding agent
#'
#' Returns the conventional directory path where custom agents for a given
#' coding agent are stored. The path is not expanded (i.e., `~` is not
#' resolved to the home directory). Use [fs::path_expand()] if you need an
#' absolute path.
#'
#' @param agent One of `"claude_code"` (or its alias `"claude"`),
#'   `"openclaw"`, `"codex"`, `"cursor"`, `"gemini_cli"`,
#'   `"github_copilot"` (or its alias `"copilot"`), or `"posit_ai"` (or its
#'   alias `"posit"`). If `NULL` (the default), the agent is resolved in
#'   order: (1) the `WF_AGENT` environment variable, (2) a scan of the
#'   current working directory for a recognised agent config folder
#'   (`.claude`, `.cursor`, etc.), and (3) a final fallback to
#'   `"claude_code"`. Set `WF_AGENT` in your `.Renviron` (e.g. with
#'   [usethis::edit_r_environ()]) to avoid passing `agent` every time.
#' @param scope One of `"project"` (a path relative to the current working
#'   directory, suitable for committing to version control) or `"global"` (a
#'   path in the user's home directory, available across all projects).
#'
#' @return A length-1 character vector giving the conventional agents path.
#' @export
#'
#' @examples
#' agent_path('claude_code', 'project')
#' agent_path('claude', 'project') # alias for claude_code
#' agent_path('cursor', 'global')
#' agent_path() # auto-detects from WF_AGENT, dir scan, or falls back to claude_code
agent_path <- function(agent = NULL, scope = c('project', 'global')) {
  scope <- rlang::arg_match(scope)
  get_scope_path(agent, scope, agent_paths)
}
