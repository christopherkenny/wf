skill_paths <- make_scope_paths('skills')

skill_topics <- make_topics('skill')

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
