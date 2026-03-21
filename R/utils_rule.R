rule_paths <- list(
  claude_code = list(
    project = '.claude/rules',
    global = '~/.claude/rules'
  ),
  openclaw = list(
    project = '.openclaw/rules',
    global = '~/.openclaw/rules'
  ),
  codex = list(
    project = '.codex/rules',
    global = '~/.codex/rules'
  ),
  cursor = list(
    project = '.cursor/rules',
    global = '~/.cursor/rules'
  ),
  gemini_cli = list(
    project = '.gemini/rules',
    global = '~/.gemini/rules'
  ),
  github_copilot = list(
    project = '.copilot/rules',
    global = '~/.copilot/rules'
  ),
  posit_ai = list(
    project = '.positai/rules',
    global = '~/.positai/rules'
  )
)

rule_topics <- c(
  'claude-rule',
  'cursor-rule',
  'codex-rule',
  'gemini-rule',
  'copilot-rule',
  'ai-coding-rule'
)

rule_lock_section <- 'rules'

resolve_rule_path <- function(path) {
  resolve_path(path, rule_paths, 'rules')
}

# Validate that a file is a valid rule (has a name, from frontmatter or filename)
validate_rule_file <- function(file, name_fallback) {
  if (!fs::file_exists(file)) {
    cli::cli_abort('Rule file not found at {.path {file}}.')
  }
  meta <- read_md_meta(file)
  if (is.null(meta$name) || !nzchar(meta$name %||% '')) {
    meta$name <- name_fallback
  }
  invisible(meta)
}
