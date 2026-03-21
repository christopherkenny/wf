hook_settings_paths <- list(
  claude_code = list(
    project = '.claude/settings.json',
    local = '.claude/settings.local.json',
    global = '~/.claude/settings.json'
  ),
  openclaw = list(
    project = '.openclaw/settings.json',
    local = '.openclaw/settings.local.json',
    global = '~/.openclaw/settings.json'
  ),
  codex = list(
    project = '.codex/settings.json',
    local = '.codex/settings.local.json',
    global = '~/.codex/settings.json'
  ),
  cursor = list(
    project = '.cursor/settings.json',
    local = '.cursor/settings.local.json',
    global = '~/.cursor/settings.json'
  ),
  gemini_cli = list(
    project = '.gemini/settings.json',
    local = '.gemini/settings.local.json',
    global = '~/.gemini/settings.json'
  ),
  github_copilot = list(
    project = '.copilot/settings.json',
    local = '.copilot/settings.local.json',
    global = '~/.copilot/settings.json'
  ),
  posit_ai = list(
    project = '.positai/settings.json',
    local = '.positai/settings.local.json',
    global = '~/.positai/settings.json'
  )
)

hook_paths <- list(
  claude_code = list(project = '.claude/hooks', global = '~/.claude/hooks'),
  openclaw = list(project = '.openclaw/hooks', global = '~/.openclaw/hooks'),
  codex = list(project = '.codex/hooks', global = '~/.codex/hooks'),
  cursor = list(project = '.cursor/hooks', global = '~/.cursor/hooks'),
  gemini_cli = list(project = '.gemini/hooks', global = '~/.gemini/hooks'),
  github_copilot = list(project = '.copilot/hooks', global = '~/.copilot/hooks'),
  posit_ai = list(project = '.positai/hooks', global = '~/.positai/hooks')
)

hook_lock_file <- '.hook-lock.json'

hook_events <- c(
  'PreToolUse', 'PostToolUse', 'UserPromptSubmit', 'Stop', 'SubagentStop'
)

hook_topics <- c('claude-hook', 'cursor-hook', 'ai-coding-hook', 'claude-code-hook')

# Resolve to a concrete settings.json path (supports project/local/global scope).
resolve_hook_settings_path <- function(path, agent, scope) {
  if (!is.null(path)) {
    return(path)
  }
  agent <- agent %||% Sys.getenv('WF_AGENT', unset = '')
  if (!nzchar(agent)) {
    agent <- detect_agent() %||% 'claude_code'
  }
  agent <- agent_aliases[[agent]] %||% agent
  agents <- names(hook_settings_paths)
  if (!agent %in% agents) {
    cli::cli_abort(
      c(
        '{.arg agent} must be one of {.or {.val {agents}}}.',
        'x' = 'Got {.val {agent}}.'
      )
    )
  }
  hook_settings_paths[[agent]][[scope]]
}

# Resolve to a concrete hooks directory path.
resolve_hook_path <- function(path) resolve_path(path, hook_paths, 'hooks')

# Derive default settings.json path from a hooks directory path
default_settings_for_hook_dir <- function(hook_dir) {
  fs::path(fs::path_dir(hook_dir), 'settings.json')
}

# Read settings.json; returns a list (empty hooks section if file missing)
read_settings <- function(path) {
  path <- fs::path_expand(path)
  if (!fs::file_exists(path)) {
    return(list(hooks = list()))
  }
  jsonlite::read_json(path)
}

# Write settings back to disk
write_settings <- function(path, settings) {
  path <- fs::path_expand(path)
  fs::dir_create(fs::path_dir(path), recurse = TRUE)
  jsonlite::write_json(settings, path, auto_unbox = TRUE, pretty = TRUE)
  invisible(path)
}
