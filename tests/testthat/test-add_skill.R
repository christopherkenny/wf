make_fixture_skill <- function(
  dir,
  name = 'my-skill',
  description = 'A test skill.'
) {
  skill_dir <- fs::path(dir, name)
  fs::dir_create(skill_dir)
  writeLines(
    c(
      '---',
      paste0('name: ', name),
      paste0('description: ', description),
      '---',
      '',
      '# My Skill',
      '',
      'Instructions here.'
    ),
    fs::path(skill_dir, 'SKILL.md')
  )
  skill_dir
}

test_that('add_skill installs a local skill', {
  tmp <- withr::local_tempdir()
  src <- withr::local_tempdir()
  fixture <- make_fixture_skill(src)
  dest_dir <- fs::path(tmp, 'skills')

  result <- add_skill(fixture, dest_dir)

  expect_identical(result, fs::path(dest_dir, 'my-skill'))
  expect_true(fs::dir_exists(fs::path(dest_dir, 'my-skill')))
  expect_true(fs::file_exists(fs::path(dest_dir, 'my-skill', 'SKILL.md')))
})

test_that('add_skill writes lock file', {
  tmp <- withr::local_tempdir()
  src <- withr::local_tempdir()
  fixture <- make_fixture_skill(src)
  dest_dir <- fs::path(tmp, 'skills')

  add_skill(fixture, dest_dir)

  lock <- jsonlite::read_json(fs::path(dest_dir, '.skill-lock.json'))
  expect_true('my-skill' %in% names(lock))
  expect_identical(lock[['my-skill']]$type, 'local')
})

test_that('add_skill errors if skill already installed without overwrite', {
  tmp <- withr::local_tempdir()
  src <- withr::local_tempdir()
  fixture <- make_fixture_skill(src)
  dest_dir <- fs::path(tmp, 'skills')
  add_skill(fixture, dest_dir)

  expect_snapshot(
    add_skill(fixture, dest_dir),
    error = TRUE,
    transform = snap_replace(fs::path(dest_dir, 'my-skill'))
  )
})

test_that('add_skill replaces skill with overwrite = TRUE', {
  tmp <- withr::local_tempdir()
  src <- withr::local_tempdir()
  fixture <- make_fixture_skill(src)
  dest_dir <- fs::path(tmp, 'skills')
  add_skill(fixture, dest_dir)

  expect_no_error(add_skill(fixture, dest_dir, overwrite = TRUE))
  expect_true(fs::dir_exists(fs::path(dest_dir, 'my-skill')))
})

test_that('add_skill errors if local source does not exist', {
  tmp <- withr::local_tempdir()
  expect_snapshot(
    add_skill(fs::path(tmp, 'nonexistent'), fs::path(tmp, 'skills')),
    error = TRUE,
    transform = snap_replace(fs::path(tmp, 'nonexistent'))
  )
})

test_that('add_skill errors if source has no SKILL.md', {
  tmp <- withr::local_tempdir()
  src <- withr::local_tempdir()
  empty_dir <- fs::path(src, 'empty-skill')
  fs::dir_create(empty_dir)
  expect_snapshot(
    add_skill(empty_dir, fs::path(tmp, 'skills')),
    error = TRUE,
    transform = snap_replace(empty_dir)
  )
})

test_that('add_skill returns path invisibly', {
  tmp <- withr::local_tempdir()
  src <- withr::local_tempdir()
  fixture <- make_fixture_skill(src)
  expect_invisible(add_skill(fixture, fs::path(tmp, 'skills')))
})

test_that('add_skill accepts agent name shorthand as path', {
  tmp <- withr::local_tempdir()
  src <- withr::local_tempdir()
  fixture <- make_fixture_skill(src)
  withr::with_dir(tmp, {
    result <- add_skill(fixture, 'claude_code')
    expect_identical(result, fs::path('.claude/skills', 'my-skill'))
    expect_true(fs::dir_exists(fs::path(tmp, '.claude/skills/my-skill')))
  })
})

test_that('parse_gh_source extracts owner and repo from shorthand', {
  result <- wf:::parse_gh_source('owner/repo')
  expect_identical(result$owner, 'owner')
  expect_identical(result$repo, 'repo')
  expect_null(result$path)
})

test_that('parse_gh_source extracts owner and repo from full URL', {
  result <- wf:::parse_gh_source('https://github.com/owner/repo')
  expect_identical(result$owner, 'owner')
  expect_identical(result$repo, 'repo')
  expect_null(result$path)
})

test_that('parse_gh_source extracts path from subdirectory URL', {
  result <- wf:::parse_gh_source(
    'https://github.com/owner/skills/tree/main/skills/proofread'
  )
  expect_identical(result$owner, 'owner')
  expect_identical(result$repo, 'skills')
  expect_identical(result$path, 'skills/proofread')
})

test_that('add_skill skill arg resolves to skills/ subdirectory', {
  tmp <- withr::local_tempdir()
  src <- withr::local_tempdir()
  fixture <- make_fixture_skill(src)
  dest_dir <- fs::path(tmp, 'skills')

  local_mocked_bindings(
    gh_download_skill = function(owner, repo, path = NULL) {
      expect_identical(path, 'skills/my-skill')
      fixture
    },
    gh_latest_sha = function(owner, repo) 'abc123'
  )

  add_skill('christopherkenny/skills', dest_dir, skill = 'my-skill')

  lock <- jsonlite::read_json(fs::path(dest_dir, '.skill-lock.json'))
  expect_identical(
    lock[['my-skill']]$source,
    'https://github.com/christopherkenny/skills/tree/HEAD/skills/my-skill'
  )
})

test_that('add_skill installs from a GitHub subdirectory URL', {
  tmp <- withr::local_tempdir()
  src <- withr::local_tempdir()
  fixture <- make_fixture_skill(src)
  dest_dir <- fs::path(tmp, 'skills')

  local_mocked_bindings(
    gh_download_skill = function(owner, repo, path = NULL) fixture,
    gh_latest_sha = function(owner, repo) 'abc123'
  )

  add_skill(
    'https://github.com/christopherkenny/skills/tree/main/skills/my-skill',
    dest_dir
  )

  lock <- jsonlite::read_json(fs::path(dest_dir, '.skill-lock.json'))
  expect_identical(
    lock[['my-skill']]$source,
    'https://github.com/christopherkenny/skills/tree/HEAD/skills/my-skill'
  )
  expect_identical(lock[['my-skill']]$sha, 'abc123')
})
