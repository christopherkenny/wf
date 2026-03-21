#' Search for agents on GitHub
#'
#' Searches GitHub for repositories tagged with an agent topic and matching
#' a keyword query. Searches across all supported agent topic conventions
#' (e.g. `claude-agent`, `cursor-agent`).
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
#' find_agent('code-review')
#' }
find_agent <- function(query) {
  find_gh_items(query, agent_topics)
}
