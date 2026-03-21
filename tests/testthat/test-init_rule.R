test_that('init_rule creates a .md file', {
  tmp <- withr::local_tempdir()
  result <- init_rule('my-rule', tmp)

  expect_identical(result, fs::path(tmp, 'my-rule.md'))
  expect_true(fs::file_exists(result))
})

test_that('init_rule file contains name in frontmatter', {
  tmp <- withr::local_tempdir()
  init_rule('my-rule', tmp)

  meta <- wf:::read_md_meta(fs::path(tmp, 'my-rule.md'))
  expect_identical(meta$name, 'my-rule')
})

test_that('init_rule errors if file already exists', {
  tmp <- withr::local_tempdir()
  init_rule('my-rule', tmp)
  expect_snapshot(
    init_rule('my-rule', tmp),
    error = TRUE,
    transform = snap_replace(fs::path(tmp, 'my-rule.md'))
  )
})

test_that('init_rule returns path invisibly', {
  expect_invisible(init_rule('my-rule', withr::local_tempdir()))
})
