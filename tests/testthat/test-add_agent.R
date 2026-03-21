make_fixture_agent <- function(dir, name = 'my-agent', description = 'A test agent.') {
  fs::dir_create(dir)
  file <- fs::path(dir, paste0(name, '.md'))
  writeLines(
    c(
      '---',
      paste0('name: ', name),
      paste0('description: ', description),
      '---',
      '',
      '# My Agent',
      '',
      'System prompt here.'
    ),
    file
  )
  file
}

test_that('add_agent installs a local agent', {
  tmp <- withr::local_tempdir()
  src <- withr::local_tempdir()
  fixture <- make_fixture_agent(src)
  dest_dir <- fs::path(tmp, 'agents')

  result <- add_agent(fixture, path = dest_dir)

  expect_identical(result, fs::path(dest_dir, 'my-agent.md'))
  expect_true(fs::file_exists(fs::path(dest_dir, 'my-agent.md')))
})

test_that('add_agent writes lock file', {
  tmp <- withr::local_tempdir()
  src <- withr::local_tempdir()
  fixture <- make_fixture_agent(src)
  dest_dir <- fs::path(tmp, 'agents')

  add_agent(fixture, path = dest_dir)

  lock <- jsonlite::read_json(fs::path(tmp, '.wf-lock.json'))$agents
  expect_identical(names(lock), 'my-agent')
  expect_identical(lock[['my-agent']]$type, 'local')
})

test_that('add_agent errors if already installed without overwrite', {
  tmp <- withr::local_tempdir()
  src <- withr::local_tempdir()
  fixture <- make_fixture_agent(src)
  dest_dir <- fs::path(tmp, 'agents')
  add_agent(fixture, path = dest_dir)

  expect_snapshot(
    add_agent(fixture, path = dest_dir),
    error = TRUE,
    transform = snap_replace(fs::path(dest_dir, 'my-agent.md'))
  )
})

test_that('add_agent replaces with overwrite = TRUE', {
  tmp <- withr::local_tempdir()
  src <- withr::local_tempdir()
  fixture <- make_fixture_agent(src)
  dest_dir <- fs::path(tmp, 'agents')
  add_agent(fixture, path = dest_dir)

  expect_no_error(add_agent(fixture, path = dest_dir, overwrite = TRUE))
  expect_true(fs::file_exists(fs::path(dest_dir, 'my-agent.md')))
})

test_that('add_agent errors if local source does not exist', {
  tmp <- withr::local_tempdir()
  expect_snapshot(
    add_agent(fs::path(tmp, 'nonexistent.md'), path = fs::path(tmp, 'agents')),
    error = TRUE,
    transform = snap_replace(fs::path(tmp, 'nonexistent.md'))
  )
})

test_that('add_agent returns path invisibly', {
  tmp <- withr::local_tempdir()
  src <- withr::local_tempdir()
  fixture <- make_fixture_agent(src)
  expect_invisible(add_agent(fixture, path = fs::path(tmp, 'agents')))
})

test_that('add_agent agent arg resolves to agents/ subdirectory', {
  tmp <- withr::local_tempdir()
  src <- withr::local_tempdir()
  # repo root with agents/my-agent.md
  agents_dir <- fs::path(src, 'agents')
  make_fixture_agent(agents_dir)
  dest_dir <- fs::path(tmp, 'agents')

  local_mocked_bindings(
    gh_download = function(owner, repo) src,
    gh_latest_sha = function(owner, repo) 'abc123'
  )

  add_agent('owner/repo', agent = 'my-agent', path = dest_dir)

  lock <- jsonlite::read_json(fs::path(tmp, '.wf-lock.json'))$agents
  expect_identical(
    lock[['my-agent']]$source,
    'https://github.com/owner/repo/tree/HEAD/agents/my-agent.md'
  )
  expect_identical(lock[['my-agent']]$sha, 'abc123')
})

test_that('add_agent installs from repo root AGENT.md', {
  tmp <- withr::local_tempdir()
  src <- withr::local_tempdir()
  writeLines(
    c('---', 'name: my-agent', 'description: An agent.', '---'),
    fs::path(src, 'AGENT.md')
  )
  dest_dir <- fs::path(tmp, 'agents')

  local_mocked_bindings(
    gh_download = function(owner, repo) src,
    gh_latest_sha = function(owner, repo) 'abc123'
  )

  add_agent('owner/repo', path = dest_dir)

  expect_true(fs::file_exists(fs::path(dest_dir, 'my-agent.md')))
})
