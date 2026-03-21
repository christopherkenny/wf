#' Search for rules on GitHub
#'
#' Searches GitHub for repositories tagged with a rule topic and matching
#' a keyword query. Searches across all supported rule topic conventions
#' (e.g. `claude-rule`, `cursor-rule`).
#'
#' @param query Keyword to search for.
#'
#' @return A data frame with columns:
#'   - `name`: repository name.
#'   - `description`: repository description.
#'   - `owner`: repository owner login.
#'   - `url`: full URL of the repository.
#'   - `stars`: number of GitHub stars.
#' @export
#'
#' @examplesIf tryCatch(gh::gh('/rate_limit')$resources$search$remaining > 0L, error = function(e) FALSE)
#' \donttest{
#' find_rule('testing')
#' }
find_rule <- function(query) {
  find_gh_items(query, rule_topics)
}
