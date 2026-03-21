agent_paths <- make_scope_paths('agents')

agent_topics <- make_topics('agent')

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
