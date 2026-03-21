rule_paths <- make_scope_paths('rules')

rule_topics <- make_topics('rule')

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
