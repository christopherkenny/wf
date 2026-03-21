test_that('init_hook creates a shell script file', {
  tmp <- withr::local_tempdir()
  result <- init_hook('my-hook', tmp)
  expect_true(fs::file_exists(result))
  expect_identical(fs::path_ext(result), 'sh')
})

test_that('init_hook returns path invisibly', {
  tmp <- withr::local_tempdir()
  expect_invisible(init_hook('my-hook', tmp))
})

test_that('init_hook errors if file already exists', {
  tmp <- withr::local_tempdir()
  init_hook('my-hook', tmp)
  expect_snapshot(init_hook('my-hook', tmp), error = TRUE, transform = snap_replace(tmp))
})

test_that('init_hook errors on invalid name', {
  expect_snapshot(init_hook('Bad Name', tempfile()), error = TRUE)
})
