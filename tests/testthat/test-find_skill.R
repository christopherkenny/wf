make_gh_search_response <- function(items = list()) {
  list(
    total_count = length(items),
    incomplete_results = FALSE,
    items = items
  )
}

make_gh_item <- function(
  name = 'test-skill',
  description = 'A test skill',
  owner = 'testowner',
  url = 'https://github.com/testowner/test-skill',
  stars = 42L
) {
  list(
    name = name,
    description = description,
    owner = list(login = owner),
    html_url = url,
    stargazers_count = stars
  )
}

test_that('find_skill returns correct columns', {
  local_mocked_bindings(
    gh_search_repos = function(q, per_page) {
      make_gh_search_response(list(make_gh_item()))
    }
  )
  result <- find_skill('test-skill')
  expect_named(result, c('name', 'description', 'owner', 'url', 'stars'))
})

test_that('find_skill errors without query', {
  expect_snapshot(find_skill(), error = TRUE)
})

test_that('find_skill returns empty data frame when no results', {
  local_mocked_bindings(
    gh_search_repos = function(q, per_page) make_gh_search_response()
  )
  result <- find_skill('xyzzy-no-results')
  expect_identical(nrow(result), 0L)
  expect_named(result, c('name', 'description', 'owner', 'url', 'stars'))
})

test_that('find_skill returns correct values from response', {
  item <- make_gh_item(
    name = 'my-skill',
    description = 'Does things',
    owner = 'alice',
    url = 'https://github.com/alice/my-skill',
    stars = 10L
  )
  local_mocked_bindings(
    gh_search_repos = function(q, per_page) make_gh_search_response(list(item))
  )
  result <- find_skill('my-skill')
  expect_identical(result$name, 'my-skill')
  expect_identical(result$owner, 'alice')
  expect_identical(result$stars, 10L)
})

test_that('find_skill errors on network failure', {
  local_mocked_bindings(
    gh_search_repos = function(q, per_page) {
      cli::cli_abort('network error')
    }
  )
  expect_snapshot(find_skill('rstats'), error = TRUE)
})
