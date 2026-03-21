test_that('list_hooks returns empty data frame with correct columns', {
  result <- list_hooks(settings = tempfile(fileext = '.json'))
  expect_s3_class(result, 'data.frame')
  expect_named(result, c('event', 'matcher', 'command', 'file'))
  expect_identical(nrow(result), 0L)
})

test_that('list_hooks returns one row per hook command', {
  tmp <- withr::local_tempdir()
  settings_file <- fs::path(tmp, 'settings.json')

  register_hook('PreToolUse', 'echo one', path = settings_file)
  register_hook('PreToolUse', 'echo two', path = settings_file)
  register_hook('Stop', 'cleanup.sh', path = settings_file)

  result <- list_hooks(settings = settings_file)
  expect_identical(nrow(result), 3L)
  expect_true('echo one' %in% result$command)
  expect_true('cleanup.sh' %in% result$command)
})

test_that('list_hooks includes matcher column', {
  tmp <- withr::local_tempdir()
  settings_file <- fs::path(tmp, 'settings.json')

  register_hook('PreToolUse', 'echo hello', matcher = 'Bash', path = settings_file)

  result <- list_hooks(settings = settings_file)
  expect_identical(result$matcher[[1]], 'Bash')
})

test_that('list_hooks file column is NA when no path given', {
  tmp <- withr::local_tempdir()
  settings_file <- fs::path(tmp, 'settings.json')

  register_hook('Stop', 'echo done', path = settings_file)

  result <- list_hooks(settings = settings_file)
  expect_true(is.na(result$file[[1]]))
})

test_that('list_hooks file column populated for add_hook-installed hooks', {
  src <- withr::local_tempfile(fileext = '.sh')
  writeLines(c('#!/bin/bash', 'echo hello'), src)
  tmp_root <- withr::local_tempdir()
  tmp <- fs::path(tmp_root, 'hooks')
  settings_file <- fs::path(tmp_root, 'settings.json')

  add_hook(src, event = 'PreToolUse', path = tmp, settings = settings_file)

  result <- list_hooks(path = tmp, settings = settings_file)
  expect_false(is.na(result$file[[1]]))
})
