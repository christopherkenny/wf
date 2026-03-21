#' Check installed skills for available updates
#'
#' Compares each installed skill's recorded commit SHA against the latest
#' commit on GitHub. Local skills are reported as not updatable.
#'
#' @param path `r roxy_path('skill', 'skill_path')`
#'
#' @return `r roxy_check_cols('skill')`
#' @export
#'
#' @examples
#' check_skills(tempfile())
check_skills <- function(path = NULL) {
  path <- resolve_skill_path(path)
  check_lock_items(read_lock(path, skill_lock_section))
}
