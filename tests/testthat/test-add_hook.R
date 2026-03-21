test_that('add_hook installs a local script file', {
  src <- withr::local_tempfile(fileext = '.sh')
  writeLines(c('#!/bin/bash', 'echo hello'), src)
  tmp_root <- withr::local_tempdir()
  tmp <- fs::path(tmp_root, 'hooks')
  settings_file <- fs::path(tmp_root, 'settings.json')

  dest <- add_hook(src, event = 'PreToolUse', path = tmp, settings = settings_file)

  expect_true(fs::file_exists(dest))
})

test_that('add_hook registers the hook in settings.json', {
  src <- withr::local_tempfile(fileext = '.sh')
  writeLines(c('#!/bin/bash', 'echo hello'), src)
  tmp_root <- withr::local_tempdir()
  tmp <- fs::path(tmp_root, 'hooks')
  settings_file <- fs::path(tmp_root, 'settings.json')

  add_hook(src, event = 'PreToolUse', path = tmp, settings = settings_file)

  settings <- jsonlite::read_json(settings_file)
  expect_false(is.null(settings$hooks$PreToolUse))
})

test_that('add_hook writes lock file entry', {
  src <- withr::local_tempfile(fileext = '.sh')
  writeLines(c('#!/bin/bash', 'echo hello'), src)
  tmp_root <- withr::local_tempdir()
  tmp <- fs::path(tmp_root, 'hooks')
  settings_file <- fs::path(tmp_root, 'settings.json')

  add_hook(src, event = 'PreToolUse', path = tmp, settings = settings_file)

  lock <- wf:::read_lock(tmp, 'hooks')
  name <- fs::path_ext_remove(fs::path_file(src))
  expect_false(is.null(lock[[name]]))
  expect_identical(lock[[name]]$event, 'PreToolUse')
})

test_that('add_hook errors if hook already installed', {
  src_dir <- withr::local_tempdir()
  src <- fs::path(src_dir, 'my-hook.sh')
  writeLines(c('#!/bin/bash', 'echo hello'), src)
  tmp_root <- withr::local_tempdir()
  tmp <- fs::path(tmp_root, 'hooks')
  settings_file <- fs::path(tmp_root, 'settings.json')

  add_hook(src, event = 'PreToolUse', path = tmp, settings = settings_file)
  expect_snapshot(
    add_hook(src, event = 'PreToolUse', path = tmp, settings = settings_file),
    error = TRUE,
    transform = snap_replace(tmp)
  )
})

test_that('add_hook overwrite = TRUE replaces existing', {
  src <- withr::local_tempfile(fileext = '.sh')
  writeLines(c('#!/bin/bash', 'echo hello'), src)
  tmp_root <- withr::local_tempdir()
  tmp <- fs::path(tmp_root, 'hooks')
  settings_file <- fs::path(tmp_root, 'settings.json')

  add_hook(src, event = 'PreToolUse', path = tmp, settings = settings_file)
  dest <- add_hook(
    src,
    event = 'PreToolUse', path = tmp,
    settings = settings_file, overwrite = TRUE
  )

  expect_true(fs::file_exists(dest))
})

test_that('add_hook errors on local source that does not exist', {
  tmp_root <- withr::local_tempdir()
  tmp <- fs::path(tmp_root, 'hooks')
  settings_file <- fs::path(tmp_root, 'settings.json')
  expect_snapshot(
    add_hook('/no/such/hook.sh',
      event = 'PreToolUse', path = tmp,
      settings = settings_file
    ),
    error = TRUE
  )
})

test_that('add_hook returns dest path invisibly', {
  src <- withr::local_tempfile(fileext = '.sh')
  writeLines(c('#!/bin/bash', 'echo done'), src)
  tmp_root <- withr::local_tempdir()
  tmp <- fs::path(tmp_root, 'hooks')
  settings_file <- fs::path(tmp_root, 'settings.json')
  expect_invisible(
    add_hook(src, event = 'Stop', path = tmp, settings = settings_file)
  )
})

test_that('add_hook with GitHub source uses gh_download mock', {
  src <- withr::local_tempdir()
  hooks_subdir <- fs::path(src, 'hooks')
  fs::dir_create(hooks_subdir)
  writeLines(c('#!/bin/bash', 'echo gh'), fs::path(hooks_subdir, 'my-hook.sh'))

  tmp_root <- withr::local_tempdir()
  tmp <- fs::path(tmp_root, 'hooks')
  settings_file <- fs::path(tmp_root, 'settings.json')

  local_mocked_bindings(
    gh_download = function(owner, repo) src,
    gh_latest_sha = function(owner, repo) 'abc123',
    .env = asNamespace('wf')
  )

  add_hook(
    'owner/repo',
    event = 'PreToolUse', hook = 'my-hook',
    path = tmp, settings = settings_file
  )

  lock <- wf:::read_lock(tmp, 'hooks')
  expect_false(is.null(lock[['my-hook']]))
  expect_identical(lock[['my-hook']]$sha, 'abc123')
})
