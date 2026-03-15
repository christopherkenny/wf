#' Get the conventional skill path for an agent
#'
#' Returns the conventional directory path where skills for a given agent are
#' stored. The path is not expanded (i.e., `~` is not resolved to the home
#' directory). Use [fs::path_expand()] if you need an absolute path.
#'
#' @param agent One of `"claude_code"` (or its alias `"claude"`),
#'   `"openclaw"`, `"codex"`, `"cursor"`, `"gemini_cli"`,
#'   `"github_copilot"` (or its alias `"copilot"`), or `"posit_ai"` (or its
#'   alias `"posit"`). If
#'   `NULL` (the default), the agent is resolved in
#'   order: (1) the `WF_AGENT` environment variable, (2) a scan of the current
#'   working directory for a recognised agent config folder (`.claude`,
#'   `.cursor`, etc.), and (3) a final fallback to `"claude_code"`. Set
#'   `WF_AGENT` in your `.Renviron` (e.g. with [usethis::edit_r_environ()])
#'   to avoid passing `agent` every time.
#' @param scope One of `"project"` (a path relative to the current working
#'   directory, suitable for committing to version control) or `"global"` (a
#'   path in the user's home directory, available across all projects).
#'
#' @return A length-1 character vector giving the conventional skill path.
#' @export
#'
#' @examples
#' skill_path('claude_code', 'project')
#' skill_path('claude', 'project') # alias for claude_code
#' skill_path('github_copilot', 'project')
#' skill_path('copilot', 'project') # alias for github_copilot
#' skill_path('posit_ai', 'project')
#' skill_path('posit', 'project') # alias for posit_ai
#' skill_path('cursor', 'global')
#' skill_path() # auto-detects from WF_AGENT, dir scan, or falls back to claude_code
skill_path <- function(agent = NULL, scope = c('project', 'global')) {
  agent <- agent %||% Sys.getenv('WF_AGENT', unset = '')
  if (!nzchar(agent)) {
    agent <- detect_agent() %||% 'claude_code'
  }
  agent <- agent_aliases[[agent]] %||% agent
  scope <- rlang::arg_match(scope)
  agents <- names(skill_paths)
  if (!agent %in% agents) {
    cli::cli_abort(
      c(
        '{.arg agent} must be one of {.or {.val {agents}}}.',
        'x' = 'Got {.val {agent}}.'
      )
    )
  }
  skill_paths[[agent]][[scope]]
}
