#' Create a new skill template
#'
#' Creates a new skill directory at `path/name/` containing a template
#' `SKILL.md` file ready to be filled in.
#'
#' @param name Skill name. Must be 1-64 characters, lowercase alphanumeric with
#'   single hyphens (no consecutive `--`), and cannot start or end with a
#'   hyphen. Consider using a gerund form (e.g. `"parsing-logs"`).
#' @param path Directory in which to create the skill. The skill directory
#'   itself will be `path/name`. Can be one of:
#'   - A known agent name such as `"claude_code"` or `"github_copilot"` to
#'     use that agent's conventional project-scope path (see [skill_path()]
#'     for the full list).
#'   - A character string giving the directory path directly.
#'   - `NULL` (the default), in which case the path is resolved from the
#'     `WF_AGENT` environment variable, or by prompting in interactive
#'     sessions. Set `WF_AGENT` in your `.Renviron` (e.g. with
#'     [usethis::edit_r_environ()]) to avoid the prompt.
#'
#' @return The path to the new skill directory, invisibly.
#' @export
#'
#' @examples
#' init_skill('my-skill', tempfile())
init_skill <- function(name, path = NULL) {
  check_skill_name(name)
  path <- resolve_path(path)
  skill_dir <- fs::path(path, name)
  if (fs::dir_exists(skill_dir)) {
    cli::cli_abort(
      'Skill directory {.path {skill_dir}} already exists.'
    )
  }
  fs::dir_create(skill_dir, recurse = TRUE)
  title <- paste0(
    toupper(substring(name, 1, 1)),
    gsub('-', ' ', substring(name, 2))
  )
  writeLines(
    c(
      '---',
      paste0('name: ', name),
      'description: >',
      '  What this skill does and when to use it.',
      '---',
      '',
      paste0('# ', title),
      '',
      'Add your skill instructions here.'
    ),
    fs::path(skill_dir, 'SKILL.md')
  )
  cli::cli_inform('Created skill {.val {name}} at {.path {skill_dir}}.')
  invisible(skill_dir)
}

check_skill_name <- function(name) {
  if (!is.character(name) || length(name) != 1 || is.na(name)) {
    cli::cli_abort('{.arg name} must be a single non-missing string.')
  }
  if (nchar(name) == 0 || nchar(name) > 64) {
    cli::cli_abort(
      '{.arg name} must be between 1 and 64 characters, not {nchar(name)}.'
    )
  }
  if (!grepl('^[a-z0-9]([a-z0-9-]*[a-z0-9])?$', name)) {
    cli::cli_abort(
      c(
        '{.arg name} must be lowercase alphanumeric with single hyphens.',
        'i' = 'It cannot start or end with a hyphen.',
        'i' = 'It cannot contain consecutive hyphens.',
        'x' = 'Got {.val {name}}.'
      )
    )
  }
  if (grepl('--', name)) {
    cli::cli_abort(
      c(
        '{.arg name} cannot contain consecutive hyphens.',
        'x' = 'Got {.val {name}}.'
      )
    )
  }
  invisible(name)
}
