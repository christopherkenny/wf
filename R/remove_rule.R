#' Remove an installed rule
#'
#' Deletes a rule file from a rules directory and removes it from the lock
#' file.
#'
#' @param name The name of the rule to remove (without the `.md` extension).
#' @param path `r roxy_path('rule', 'rule_path')`
#' @param force `r roxy_force()`
#'
#' @return The name of the removed rule, invisibly.
#' @export
#'
#' @examples
#' src <- tempfile(fileext = '.md')
#' writeLines(
#'   c('---', 'name: example', 'description: An example rule.', '---'),
#'   src
#' )
#' tmp <- tempfile()
#' add_rule(src, path = tmp)
#' remove_rule('example', tmp, force = TRUE)
remove_rule <- function(name, path = NULL, force = FALSE) {
  path <- resolve_rule_path(path)
  rule_file <- fs::path(path, paste0(name, '.md'))
  if (!fs::file_exists(rule_file)) {
    cli::cli_abort(
      'Rule {.val {name}} is not installed at {.path {path}}.'
    )
  }

  if (!force && rlang::is_interactive()) {
    cli::cli_inform('Remove rule {.val {name}} from {.path {path}}? [y/N] ')
    answer <- readline()
    if (!tolower(trimws(answer)) %in% c('y', 'yes')) {
      cli::cli_inform('Removal cancelled.')
      return(invisible(name))
    }
  }

  fs::file_delete(rule_file)

  lock <- read_lock(path, rule_lock_section)
  lock[[name]] <- NULL
  write_lock(path, lock, rule_lock_section)

  cli::cli_inform('Removed rule {.val {name}} from {.path {path}}.')
  invisible(name)
}
