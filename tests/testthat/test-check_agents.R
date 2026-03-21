test_that('check_agents returns empty data frame for empty directory', {
  result <- check_agents(tempfile())
  expect_s3_class(result, 'data.frame')
  expect_named(result, c('name', 'installed_sha', 'latest_sha', 'update_available'))
  expect_identical(nrow(result), 0L)
})

test_that('check_agents reports local agents as not updatable', {
  tmp <- withr::local_tempdir()
  src <- withr::local_tempdir()
  writeLines(
    c('---', 'name: my-agent', 'description: An agent.', '---'),
    fs::path(src, 'my-agent.md')
  )
  add_agent(fs::path(src, 'my-agent.md'), path = tmp)

  result <- check_agents(tmp)
  expect_identical(nrow(result), 1L)
  expect_true(is.na(result$installed_sha[[1]]))
  expect_false(result$update_available[[1]])
})

test_that('check_agents detects updates from github agents', {
  tmp <- withr::local_tempdir()
  src <- withr::local_tempdir()
  writeLines(
    c('---', 'name: my-agent', 'description: An agent.', '---'),
    fs::path(src, 'AGENT.md')
  )

  local_mocked_bindings(
    gh_download = function(owner, repo) src,
    gh_latest_sha = function(owner, repo) 'sha-old'
  )
  add_agent('owner/repo', path = tmp)

  local_mocked_bindings(
    gh_latest_sha = function(owner, repo) 'sha-new'
  )
  result <- check_agents(tmp)

  expect_true(result$update_available[[1]])
  expect_identical(result$installed_sha[[1]], 'sha-old')
  expect_identical(result$latest_sha[[1]], 'sha-new')
})
