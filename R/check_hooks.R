#' Check installed hooks for available updates
#'
#' Compares each installed hook's recorded commit SHA against the latest
#' commit on GitHub. Local hooks are reported as not updatable.
#'
#' @param path `r roxy_path('hook', 'hook_path')`
#'
#' @return `r roxy_check_cols('hook')`
#' @export
#'
#' @examples
#' check_hooks(tempfile())
check_hooks <- function(path = NULL) {
  path <- resolve_hook_path(path)
  check_lock_items(read_lock(path, hook_lock_section))
}
