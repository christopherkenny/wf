test_that('init_agent creates a .md file', {
  tmp <- withr::local_tempdir()
  result <- init_agent('my-agent', tmp)

  expect_identical(result, fs::path(tmp, 'my-agent.md'))
  expect_true(fs::file_exists(result))
})

test_that('init_agent file contains required frontmatter', {
  tmp <- withr::local_tempdir()
  init_agent('my-agent', tmp)

  meta <- wf:::read_md_meta(fs::path(tmp, 'my-agent.md'))
  expect_identical(meta$name, 'my-agent')
  expect_false(is.null(meta$description))
})

test_that('init_agent errors if file already exists', {
  tmp <- withr::local_tempdir()
  init_agent('my-agent', tmp)
  expect_snapshot(
    init_agent('my-agent', tmp),
    error = TRUE,
    transform = snap_replace(fs::path(tmp, 'my-agent.md'))
  )
})

test_that('init_agent returns path invisibly', {
  expect_invisible(init_agent('my-agent', withr::local_tempdir()))
})

test_that('check_item_name errors on bad names', {
  expect_snapshot(init_agent('', tempfile()), error = TRUE)
  expect_snapshot(init_agent('Bad-Name', tempfile()), error = TRUE)
  expect_snapshot(init_agent('no--double', tempfile()), error = TRUE)
})
