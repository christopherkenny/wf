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
#' @examplesIf attr(curlGetHeaders('https://api.github.com'), 'status') == 200L
#' \donttest{
#' find_rule('testing')
#' }
find_rule <- function(query) {
  find_gh_items(query, rule_topics)
}
