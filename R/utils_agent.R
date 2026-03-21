agent_paths <- list(
  claude_code = list(
    project = '.claude/agents',
    global = '~/.claude/agents'
  ),
  openclaw = list(
    project = '.openclaw/agents',
    global = '~/.openclaw/agents'
  ),
  codex = list(
    project = '.codex/agents',
    global = '~/.codex/agents'
  ),
  cursor = list(
    project = '.cursor/agents',
    global = '~/.cursor/agents'
  ),
  gemini_cli = list(
    project = '.gemini/agents',
    global = '~/.gemini/agents'
  ),
  github_copilot = list(
    project = '.copilot/agents',
    global = '~/.copilot/agents'
  ),
  posit_ai = list(
    project = '.positai/agents',
    global = '~/.positai/agents'
  )
)

agent_topics <- c(
  'claude-agent',
  'cursor-agent',
  'codex-agent',
  'gemini-agent',
  'copilot-agent',
  'ai-coding-agent'
)

agent_lock_section <- 'agents'

resolve_agent_path <- function(path) {
  resolve_path(path, agent_paths, 'agents')
}

# Validate that a file is a valid agent (has YAML frontmatter with name + description)
validate_agent_file <- function(file) {
  meta <- read_md_meta(file)
  if (is.null(meta$name) || !nzchar(meta$name)) {
    cli::cli_abort(
      '{.path {file}} is missing a {.field name} field in its frontmatter.'
    )
  }
  if (is.null(meta$description) || !nzchar(meta$description)) {
    cli::cli_abort(
      '{.path {file}} is missing a {.field description} field in its frontmatter.'
    )
  }
  invisible(meta)
}
