make_hook_lock <- function(path, entries) {
  root <- fs::path_dir(path)
  fs::dir_create(root, recurse = TRUE)
  jsonlite::write_json(
    list(hooks = entries),
    fs::path(root, '.wf-lock.json'),
    auto_unbox = TRUE,
    pretty = TRUE
  )
}

test_that('update_hooks preserves hook install metadata', {
  tmp <- withr::local_tempdir()
  make_hook_lock(
    tmp,
    list(
      `my-hook` = list(
        source = 'https://github.com/owner/repo',
        type = 'github',
        event = 'PreToolUse',
        hook = 'my-hook',
        matcher = 'Bash',
        command = fs::path(tmp, 'my-hook.sh'),
        timeout = 30,
        async = TRUE,
        sha = 'old123',
        installed_at = '2026-01-01T00:00:00Z'
      )
    )
  )

  local_mocked_bindings(
    check_hooks = function(path) {
      data.frame(
        name = 'my-hook',
        installed_sha = 'old123',
        latest_sha = 'new456',
        update_available = TRUE,
        stringsAsFactors = FALSE
      )
    },
    add_hook = function(source,
                        event,
                        hook = NULL,
                        matcher = NULL,
                        path = NULL,
                        settings = NULL,
                        overwrite = FALSE,
                        timeout = NULL,
                        async = FALSE) {
      expect_identical(source, 'https://github.com/owner/repo')
      expect_identical(event, 'PreToolUse')
      expect_identical(hook, 'my-hook')
      expect_identical(matcher, 'Bash')
      expect_identical(path, tmp)
      expect_true(overwrite)
      expect_identical(timeout, 30L)
      expect_true(async)
      invisible(fs::path(path, 'my-hook.sh'))
    }
  )

  result <- update_hooks(tmp)
  expect_identical(result, 'my-hook')
})
