#' Check installed rules for available updates
#'
#' Compares each installed rule's recorded commit SHA against the latest
#' commit on GitHub. Local rules are reported as not updatable.
#'
#' @param path `r roxy_path('rule', 'rule_path')`
#'
#' @return `r roxy_check_cols('rule')`
#' @export
#'
#' @examples
#' check_rules(tempfile())
check_rules <- function(path = NULL) {
  path <- resolve_rule_path(path)
  check_lock_items(read_lock(path, rule_lock_section))
}
