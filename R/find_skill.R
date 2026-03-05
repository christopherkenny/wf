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
  topics <- paste(paste0('topic:', skill_topics), collapse = ' OR ')
  if (is.null(query) || !nzchar(query)) {
    cli::cli_abort('{.arg query} must not be missing.')
  }
  q <- paste0(query, ' (', topics, ')')

  items <- gh_search_repos(q)$items

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
