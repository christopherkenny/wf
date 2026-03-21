test_that('check_hooks returns empty data frame for empty dir', {
  tmp_root <- withr::local_tempdir()
  result <- check_hooks(fs::path(tmp_root, 'hooks'))
  expect_s3_class(result, 'data.frame')
  expect_named(result, c('name', 'installed_sha', 'latest_sha', 'update_available'))
  expect_identical(nrow(result), 0L)
})

test_that('check_hooks returns NA sha for local hook', {
  src <- withr::local_tempfile(fileext = '.sh')
  writeLines(c('#!/bin/bash', 'echo hello'), src)
  tmp_root <- withr::local_tempdir()
  tmp <- fs::path(tmp_root, 'hooks')
  settings_file <- fs::path(tmp_root, 'settings.json')

  add_hook(src, event = 'PreToolUse', path = tmp, settings = settings_file)

  result <- check_hooks(tmp)
  expect_identical(nrow(result), 1L)
  expect_true(is.na(result$installed_sha))
  expect_false(result$update_available)
})
