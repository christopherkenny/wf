test_that('remove_hook deletes the script file', {
  src <- withr::local_tempfile(fileext = '.sh')
  writeLines(c('#!/bin/bash', 'echo hello'), src)
  tmp_root <- withr::local_tempdir()
  tmp <- fs::path(tmp_root, 'hooks')
  settings_file <- fs::path(tmp_root, 'settings.json')
  name <- fs::path_ext_remove(fs::path_file(src))

  add_hook(src, event = 'PreToolUse', path = tmp, settings = settings_file)
  remove_hook(name, path = tmp, settings = settings_file, force = TRUE)

  expect_false(any(fs::file_exists(fs::dir_ls(tmp, glob = paste0('*/', name, '.*')))))
})

test_that('remove_hook removes the settings.json registration', {
  src <- withr::local_tempfile(fileext = '.sh')
  writeLines(c('#!/bin/bash', 'echo hello'), src)
  tmp_root <- withr::local_tempdir()
  tmp <- fs::path(tmp_root, 'hooks')
  settings_file <- fs::path(tmp_root, 'settings.json')
  name <- fs::path_ext_remove(fs::path_file(src))

  add_hook(src, event = 'PreToolUse', path = tmp, settings = settings_file)
  remove_hook(name, path = tmp, settings = settings_file, force = TRUE)

  result <- list_hooks(settings = settings_file)
  expect_identical(nrow(result), 0L)
})

test_that('remove_hook updates lock file', {
  src <- withr::local_tempfile(fileext = '.sh')
  writeLines(c('#!/bin/bash', 'echo hello'), src)
  tmp_root <- withr::local_tempdir()
  tmp <- fs::path(tmp_root, 'hooks')
  settings_file <- fs::path(tmp_root, 'settings.json')
  name <- fs::path_ext_remove(fs::path_file(src))

  add_hook(src, event = 'PreToolUse', path = tmp, settings = settings_file)
  remove_hook(name, path = tmp, settings = settings_file, force = TRUE)

  lock <- wf:::read_lock(tmp, 'hooks')
  expect_null(lock[[name]])
})

test_that('remove_hook returns name invisibly', {
  src <- withr::local_tempfile(fileext = '.sh')
  writeLines(c('#!/bin/bash', 'echo done'), src)
  tmp_root <- withr::local_tempdir()
  tmp <- fs::path(tmp_root, 'hooks')
  settings_file <- fs::path(tmp_root, 'settings.json')
  name <- fs::path_ext_remove(fs::path_file(src))

  add_hook(src, event = 'Stop', path = tmp, settings = settings_file)
  expect_invisible(
    remove_hook(name, path = tmp, settings = settings_file, force = TRUE)
  )
})

test_that('remove_hook errors if hook not installed', {
  tmp_root <- withr::local_tempdir()
  tmp <- fs::path(tmp_root, 'hooks')
  expect_snapshot(
    remove_hook('ghost', path = tmp),
    error = TRUE,
    transform = snap_replace(tmp)
  )
})
