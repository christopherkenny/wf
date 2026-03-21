test_that('register_hook creates settings.json with hook entry', {
  tmp <- withr::local_tempdir()
  settings_file <- fs::path(tmp, 'settings.json')

  register_hook('PreToolUse', 'echo hello', path = settings_file)

  settings <- jsonlite::read_json(settings_file)
  expect_false(is.null(settings$hooks$PreToolUse))
  expect_identical(
    settings$hooks$PreToolUse[[1]]$hooks[[1]]$command,
    'echo hello'
  )
})

test_that('register_hook respects matcher', {
  tmp <- withr::local_tempdir()
  settings_file <- fs::path(tmp, 'settings.json')

  register_hook('PreToolUse', 'echo hello', matcher = 'Bash', path = settings_file)

  settings <- jsonlite::read_json(settings_file)
  expect_identical(settings$hooks$PreToolUse[[1]]$matcher, 'Bash')
})

test_that('register_hook appends to existing group with same matcher', {
  tmp <- withr::local_tempdir()
  settings_file <- fs::path(tmp, 'settings.json')

  register_hook('PreToolUse', 'echo one', matcher = 'Bash', path = settings_file)
  register_hook('PreToolUse', 'echo two', matcher = 'Bash', path = settings_file)

  settings <- jsonlite::read_json(settings_file)
  expect_identical(length(settings$hooks$PreToolUse), 1L)
  expect_identical(length(settings$hooks$PreToolUse[[1]]$hooks), 2L)
})

test_that('register_hook creates new group for different matcher', {
  tmp <- withr::local_tempdir()
  settings_file <- fs::path(tmp, 'settings.json')

  register_hook('PreToolUse', 'echo one', matcher = 'Bash', path = settings_file)
  register_hook('PreToolUse', 'echo two', matcher = 'Edit', path = settings_file)

  settings <- jsonlite::read_json(settings_file)
  expect_identical(length(settings$hooks$PreToolUse), 2L)
})

test_that('register_hook includes timeout when specified', {
  tmp <- withr::local_tempdir()
  settings_file <- fs::path(tmp, 'settings.json')

  register_hook('Stop', 'cleanup.sh', timeout = 30, path = settings_file)

  settings <- jsonlite::read_json(settings_file)
  expect_identical(settings$hooks$Stop[[1]]$hooks[[1]]$timeout, 30L)
})

test_that('register_hook returns path invisibly', {
  tmp <- withr::local_tempdir()
  settings_file <- fs::path(tmp, 'settings.json')
  expect_invisible(register_hook('Stop', 'echo done', path = settings_file))
})

test_that('register_hook errors on invalid event', {
  tmp <- withr::local_tempdir()
  settings_file <- fs::path(tmp, 'settings.json')
  expect_snapshot(
    register_hook('BadEvent', 'echo hi', path = settings_file),
    error = TRUE
  )
})
