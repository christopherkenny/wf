make_fixture_skill <- function(dir, name = 'my-skill', description = 'A test skill.') {
  skill_dir <- fs::path(dir, name)
  fs::dir_create(skill_dir)
  writeLines(
    c(
      '---',
      paste0('name: ', name),
      paste0('description: ', description),
      '---'
    ),
    fs::path(skill_dir, 'SKILL.md')
  )
  skill_dir
}

test_that('remove_skill deletes the skill directory', {
  tmp <- withr::local_tempdir()
  src <- withr::local_tempdir()
  fixture <- make_fixture_skill(src)
  dest_dir <- fs::path(tmp, 'skills')
  add_skill(fixture, dest_dir)

  remove_skill('my-skill', dest_dir, force = TRUE)

  expect_false(fs::dir_exists(fs::path(dest_dir, 'my-skill')))
})

test_that('remove_skill updates the lock file', {
  tmp <- withr::local_tempdir()
  src <- withr::local_tempdir()
  fixture <- make_fixture_skill(src)
  dest_dir <- fs::path(tmp, 'skills')
  add_skill(fixture, dest_dir)

  remove_skill('my-skill', dest_dir, force = TRUE)

  lock <- jsonlite::read_json(fs::path(dest_dir, '.skill-lock.json'))
  expect_false('my-skill' %in% names(lock))
})

test_that('remove_skill returns name invisibly', {
  tmp <- withr::local_tempdir()
  src <- withr::local_tempdir()
  fixture <- make_fixture_skill(src)
  dest_dir <- fs::path(tmp, 'skills')
  add_skill(fixture, dest_dir)

  expect_invisible(remove_skill('my-skill', dest_dir, force = TRUE))
})

test_that('remove_skill errors if skill not installed', {
  tmp <- withr::local_tempdir()
  expect_snapshot(
    remove_skill('nonexistent', tmp, force = TRUE),
    error = TRUE,
    transform = snap_replace(tmp)
  )
})
