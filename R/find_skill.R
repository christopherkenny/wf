#' Search for skills on GitHub
#'
#' Searches GitHub for repositories tagged with a skill topic and matching
#' a keyword query. Searches across all supported agent topic conventions
#' (e.g. `claude-skill`, `cursor-skill`).
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
#' find_skill('rstats')
#' }
find_skill <- function(query) {
  find_gh_items(query, skill_topics)
}
