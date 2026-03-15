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
#' find_skill('rstats')
find_skill <- function(query = NULL) {
  if (is.null(query) || !nzchar(query)) {
    cli::cli_abort('{.arg query} must not be missing.')
  }
  # GitHub search does not support OR between topic: qualifiers, so we run
  # one query per skill topic and deduplicate results by URL.
  items <- list()
  seen <- character()
  for (topic in skill_topics) {
    q <- paste(query, paste0('topic:', topic))
    new_items <- gh_search_repos(q)$items
    for (item in new_items) {
      if (!item$html_url %in% seen) {
        seen <- c(seen, item$html_url)
        items <- c(items, list(item))
      }
    }
  }

  if (length(items) == 0) {
    return(data.frame(
      name = character(),
      description = character(),
      owner = character(),
      url = character(),
      stars = integer(),
      stringsAsFactors = FALSE
    ))
  }

  data.frame(
    name = vapply(items, `[[`, character(1), 'name'),
    description = vapply(
      items,
      function(x) x$description %||% NA_character_,
      character(1)
    ),
    owner = vapply(items, function(x) x$owner$login, character(1)),
    url = vapply(items, `[[`, character(1), 'html_url'),
    stars = vapply(items, `[[`, integer(1), 'stargazers_count'),
    stringsAsFactors = FALSE
  )
}
