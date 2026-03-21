skill_paths <- list(
  claude_code = list(
    project = '.claude/skills',
    global = '~/.claude/skills'
  ),
  openclaw = list(
    project = '.openclaw/skills',
    global = '~/.openclaw/skills'
  ),
  codex = list(
    project = '.codex/skills',
    global = '~/.codex/skills'
  ),
  cursor = list(
    project = '.cursor/skills',
    global = '~/.cursor/skills'
  ),
  gemini_cli = list(
    project = '.gemini/skills',
    global = '~/.gemini/skills'
  ),
  github_copilot = list(
    project = '.copilot/skills',
    global = '~/.copilot/skills'
  ),
  posit_ai = list(
    project = '.positai/skills',
    global = '~/.positai/skills'
  )
)

skill_topics <- c(
  'claude-skill',
  'cursor-skill',
  'codex-skill',
  'gemini-skill',
  'copilot-skill',
  'ai-coding-skill'
)

skill_lock_section <- 'skills'

resolve_skill_path <- function(path) {
  resolve_path(path, skill_paths, 'skills')
}

# Parse YAML frontmatter from a SKILL.md file; returns a named list
read_skill_meta <- function(skill_dir) {
  read_md_meta(fs::path(skill_dir, 'SKILL.md'))
}

# Validate that a directory is a valid skill (has SKILL.md with name + description)
validate_skill_dir <- function(skill_dir) {
  meta <- read_skill_meta(skill_dir)
  if (is.null(meta$name) || !nzchar(meta$name)) {
    cli::cli_abort(
      '{.file SKILL.md} in {.path {skill_dir}} is missing a {.field name} field.'
    )
  }
  if (is.null(meta$description) || !nzchar(meta$description)) {
    cli::cli_abort(
      '{.file SKILL.md} in {.path {skill_dir}} is missing a {.field description} field.'
    )
  }
  invisible(meta)
}
