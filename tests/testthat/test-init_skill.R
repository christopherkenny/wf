test_that('init_skill creates skill directory and SKILL.md', {
  tmp <- withr::local_tempdir()
  result <- init_skill('my-skill', tmp)
  expect_identical(result, fs::path(tmp, 'my-skill'))
  expect_true(fs::dir_exists(fs::path(tmp, 'my-skill')))
  expect_true(fs::file_exists(fs::path(tmp, 'my-skill', 'SKILL.md')))
})

test_that('init_skill writes correct SKILL.md frontmatter', {
  tmp <- withr::local_tempdir()
  init_skill('test-skill', tmp)
  lines <- readLines(fs::path(tmp, 'test-skill', 'SKILL.md'))
  expect_identical(lines[[1]], '---')
  expect_identical(lines[[2]], 'name: test-skill')
})

test_that('init_skill errors if skill directory already exists', {
  tmp <- withr::local_tempdir()
  init_skill('my-skill', tmp)
  expect_snapshot(
    init_skill('my-skill', tmp),
    error = TRUE,
    transform = normalize_snap_paths
  )
})

test_that('init_skill errors on invalid skill names', {
  tmp <- withr::local_tempdir()
  expect_snapshot(init_skill('My-Skill', tmp), error = TRUE)
  expect_snapshot(init_skill('-bad', tmp), error = TRUE)
  expect_snapshot(init_skill('bad-', tmp), error = TRUE)
  expect_snapshot(init_skill('bad--name', tmp), error = TRUE)
  expect_snapshot(init_skill('', tmp), error = TRUE)
})

test_that('init_skill returns path invisibly', {
  tmp <- withr::local_tempdir()
  expect_invisible(init_skill('quiet-skill', tmp))
})
