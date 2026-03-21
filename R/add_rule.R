#' Install a rule
#'
#' Installs a rule from a GitHub repository or a local file into a rules
#' directory. Rules are Markdown files with optional YAML frontmatter. The
#' rule `name` comes from the frontmatter if present, otherwise from the
#' filename stem.
#'
#' @param source One of:
#'   - A GitHub URL pointing to a repo, e.g. `"https://github.com/owner/repo"`.
#'   - A GitHub URL pointing to a subdirectory or file, e.g.
#'     `"https://github.com/owner/repo/tree/main/path/to/rule.md"`.
#'   - A GitHub shorthand, e.g. `"owner/repo"`.
#'   - A local file path pointing to a Markdown file.
#' @param rule For multi-rule repositories that store rules under a `rules/`
#'   subdirectory, the name of the rule to install (without the `.md`
#'   extension), e.g. `rule = "testing"`. When supplied, the rule is read
#'   from `rules/<rule>.md` within the repository. Ignored when `source`
#'   already points to a specific path via `/tree/...`.
#' @param path The rules directory to install into. Can be one of:
#'   - A known coding agent name such as `"claude_code"`, `"cursor"`, or
#'     `"github_copilot"` (see [rule_path()] for the full list) to use that
#'     agent's conventional project-scope path.
#'   - A character string giving the directory path directly.
#'   - `NULL` (the default), in which case the path is resolved from the
#'     `WF_AGENT` environment variable, or by prompting in interactive
#'     sessions. Set `WF_AGENT` in your `.Renviron` (e.g. with
#'     [usethis::edit_r_environ()]) to avoid the prompt.
#' @param overwrite If `FALSE` (the default), an error is raised if the rule
#'   is already installed. Set to `TRUE` to replace it.
#'
#' @return The path to the installed rule file, invisibly.
#' @export
#'
#' @examples
#' src <- tempfile(fileext = '.md')
#' writeLines(
#'   c('---', 'name: example', 'description: An example rule.', '---'),
#'   src
#' )
#' add_rule(src, path = tempfile())
add_rule <- function(source, rule = NULL, path = NULL, overwrite = FALSE) {
  path <- resolve_rule_path(path)
  type <- parse_source(source)
  if (type == 'github') {
    gh <- parse_gh_source(source)
    if (!is.null(rule) && is.null(gh$path)) {
      gh$path <- paste0('rules/', rule, '.md')
    }
    repo_root <- gh_download(gh$owner, gh$repo)
    rule_file <- if (!is.null(gh$path)) {
      candidate <- fs::path(repo_root, gh$path)
      if (!fs::file_exists(candidate)) {
        candidate <- fs::path(repo_root, paste0(gh$path, '.md'))
      }
      if (!fs::file_exists(candidate)) {
        cli::cli_abort(
          'Path {.path {gh$path}} not found in {gh$owner}/{gh$repo}.'
        )
      }
      candidate
    } else {
      candidate <- fs::path(repo_root, 'RULE.md')
      if (!fs::file_exists(candidate)) {
        cli::cli_abort(
          'No {.file RULE.md} found in {gh$owner}/{gh$repo}.'
        )
      }
      candidate
    }
    sha <- gh_latest_sha(gh$owner, gh$repo)
    lock_source <- make_gh_lock_source(gh)
  } else {
    rule_file <- source
    if (!fs::file_exists(rule_file)) {
      cli::cli_abort('Local rule source {.path {rule_file}} does not exist.')
    }
    sha <- NULL
    lock_source <- fs::path_abs(rule_file)
  }

  name_fallback <- fs::path_ext_remove(fs::path_file(rule_file))
  meta <- validate_rule_file(rule_file, name_fallback)
  name <- meta$name
  dest <- fs::path(path, paste0(name, '.md'))

  if (fs::file_exists(dest)) {
    if (!overwrite) {
      cli::cli_abort(
        c(
          'Rule {.val {name}} is already installed at {.path {dest}}.',
          'i' = 'Use {.code overwrite = TRUE} to replace it.'
        )
      )
    }
    fs::file_delete(dest)
  }

  fs::dir_create(path, recurse = TRUE)
  fs::file_copy(rule_file, dest)

  lock <- read_lock(path, rule_lock_file)
  entry <- list(
    source = lock_source,
    type = type,
    installed_at = format(Sys.time(), '%Y-%m-%dT%H:%M:%SZ', tz = 'UTC')
  )
  if (!is.null(sha)) {
    entry$sha <- sha
  }
  lock[[name]] <- entry
  write_lock(path, lock, rule_lock_file)

  cli::cli_inform('Installed rule {.val {name}} to {.path {dest}}.')
  invisible(dest)
}
