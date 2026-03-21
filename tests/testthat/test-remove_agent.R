test_that('remove_agent removes an installed agent', {
  tmp <- withr::local_tempdir()
  src <- withr::local_tempdir()
  writeLines(
    c('---', 'name: my-agent', 'description: An agent.', '---'),
    fs::path(src, 'my-agent.md')
  )
  add_agent(fs::path(src, 'my-agent.md'), path = tmp)

  remove_agent('my-agent', tmp, force = TRUE)

  expect_false(fs::file_exists(fs::path(tmp, 'my-agent.md')))
})

test_that('remove_agent updates lock file', {
  tmp <- withr::local_tempdir()
  src <- withr::local_tempdir()
  writeLines(
    c('---', 'name: my-agent', 'description: An agent.', '---'),
    fs::path(src, 'my-agent.md')
  )
  add_agent(fs::path(src, 'my-agent.md'), path = tmp)
  remove_agent('my-agent', tmp, force = TRUE)

  lock <- wf:::read_lock(tmp, 'agents')
  expect_null(lock[['my-agent']])
})

test_that('remove_agent returns name invisibly', {
  tmp <- withr::local_tempdir()
  src <- withr::local_tempdir()
  writeLines(
    c('---', 'name: my-agent', 'description: An agent.', '---'),
    fs::path(src, 'my-agent.md')
  )
  add_agent(fs::path(src, 'my-agent.md'), path = tmp)

  expect_invisible(remove_agent('my-agent', tmp, force = TRUE))
})

test_that('remove_agent errors if agent not installed', {
  tmp <- withr::local_tempdir()
  expect_snapshot(
    remove_agent('ghost', tmp),
    error = TRUE,
    transform = snap_replace(tmp)
  )
})
