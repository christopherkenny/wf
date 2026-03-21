test_that('list_agents returns empty data frame for missing directory', {
  result <- list_agents(tempfile())
  expect_s3_class(result, 'data.frame')
  expect_named(result, c('name', 'description', 'source', 'installed_at'))
  expect_identical(nrow(result), 0L)
})

test_that('list_agents returns empty data frame for empty directory', {
  tmp <- withr::local_tempdir()
  result <- list_agents(tmp)
  expect_identical(nrow(result), 0L)
})

test_that('list_agents returns one row per installed agent', {
  tmp <- withr::local_tempdir()
  src <- withr::local_tempdir()

  writeLines(
    c('---', 'name: agent-a', 'description: Agent A.', '---'),
    fs::path(src, 'agent-a.md')
  )
  writeLines(
    c('---', 'name: agent-b', 'description: Agent B.', '---'),
    fs::path(src, 'agent-b.md')
  )
  add_agent(fs::path(src, 'agent-a.md'), path = tmp)
  add_agent(fs::path(src, 'agent-b.md'), path = tmp)

  result <- list_agents(tmp)
  expect_identical(nrow(result), 2L)
  expect_true('agent-a' %in% result$name)
  expect_true('agent-b' %in% result$name)
})

test_that('list_agents reads description from frontmatter', {
  tmp <- withr::local_tempdir()
  src <- withr::local_tempdir()
  writeLines(
    c('---', 'name: my-agent', 'description: A great agent.', '---'),
    fs::path(src, 'my-agent.md')
  )
  add_agent(fs::path(src, 'my-agent.md'), path = tmp)

  result <- list_agents(tmp)
  expect_identical(result$description[[1]], 'A great agent.')
})
