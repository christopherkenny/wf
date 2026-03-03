#' Search for skills on GitHub
#'
#' Searches GitHub for repositories tagged with the `claude-skill` topic,
#' optionally filtered by a keyword query.
#'
#' @param query Optional keyword to narrow the search. If `NULL`, all
#'   repositories with the `claude-skill` topic are returned.
#'
#' @return A data frame with columns:
#'   - `name`: repository name.
#'   - `description`: repository description.
#'   - `owner`: repository owner login.
#'   - `url`: full URL of the repository.
#'   - `stars`: number of GitHub stars.
#' @export
#'
#' @examples
#' \donttest{
#' find_skill()
#' find_skill('typescript')
#' }
find_skill <- function(query = NULL) {
  q <- if (is.null(query) || !nzchar(query)) {
    'topic:claude-skill'
  } else {
    paste0(query, ' topic:claude-skill')
  }

  body <- tryCatch(
    gh_search_repos(q),
    error = function(e) {
      cli::cli_abort(
        c(
          'Failed to search GitHub for skills.',
          'i' = 'Check your internet connection.',
          'x' = conditionMessage(e)
        )
      )
    }
  )

  items <- body$items

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
