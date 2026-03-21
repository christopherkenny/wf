make_fixture_rule <- function(dir, name = 'my-rule', description = 'A test rule.') {
  fs::dir_create(dir)
  file <- fs::path(dir, paste0(name, '.md'))
  writeLines(
    c(
      '---',
      paste0('name: ', name),
      paste0('description: ', description),
      '---',
      '',
      '# My Rule',
      '',
      'Rule content here.'
    ),
    file
  )
  file
}

test_that('add_rule installs a local rule', {
  tmp <- withr::local_tempdir()
  src <- withr::local_tempdir()
  fixture <- make_fixture_rule(src)
  dest_dir <- fs::path(tmp, 'rules')

  result <- add_rule(fixture, path = dest_dir)

  expect_identical(result, fs::path(dest_dir, 'my-rule.md'))
  expect_true(fs::file_exists(fs::path(dest_dir, 'my-rule.md')))
})

test_that('add_rule writes lock file', {
  tmp <- withr::local_tempdir()
  src <- withr::local_tempdir()
  fixture <- make_fixture_rule(src)
  dest_dir <- fs::path(tmp, 'rules')

  add_rule(fixture, path = dest_dir)

  lock <- jsonlite::read_json(fs::path(tmp, '.wf-lock.json'))$rules
  expect_identical(names(lock), 'my-rule')
  expect_identical(lock[['my-rule']]$type, 'local')
})

test_that('add_rule uses filename stem when no frontmatter name', {
  tmp <- withr::local_tempdir()
  src <- withr::local_tempdir()
  no_fm <- fs::path(src, 'unnamed.md')
  writeLines(c('# Just a rule', 'Some content.'), no_fm)

  add_rule(no_fm, path = tmp)

  expect_true(fs::file_exists(fs::path(tmp, 'unnamed.md')))
})

test_that('add_rule errors if already installed without overwrite', {
  tmp <- withr::local_tempdir()
  src <- withr::local_tempdir()
  fixture <- make_fixture_rule(src)
  add_rule(fixture, path = tmp)

  expect_snapshot(
    add_rule(fixture, path = tmp),
    error = TRUE,
    transform = snap_replace(fs::path(tmp, 'my-rule.md'))
  )
})

test_that('add_rule returns path invisibly', {
  tmp <- withr::local_tempdir()
  src <- withr::local_tempdir()
  fixture <- make_fixture_rule(src)
  expect_invisible(add_rule(fixture, path = fs::path(tmp, 'rules')))
})

test_that('add_rule rule arg resolves to rules/ subdirectory', {
  tmp <- withr::local_tempdir()
  src <- withr::local_tempdir()
  rules_dir <- fs::path(src, 'rules')
  make_fixture_rule(rules_dir)
  dest_dir <- fs::path(tmp, 'rules')

  local_mocked_bindings(
    gh_download = function(owner, repo) src,
    gh_latest_sha = function(owner, repo) 'abc123'
  )

  add_rule('owner/repo', rule = 'my-rule', path = dest_dir)

  lock <- jsonlite::read_json(fs::path(tmp, '.wf-lock.json'))$rules
  expect_identical(
    lock[['my-rule']]$source,
    'https://github.com/owner/repo/tree/HEAD/rules/my-rule.md'
  )
})
