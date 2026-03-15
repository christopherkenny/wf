make_fixture_skill <- function(
  dir,
  name = 'my-skill',
  description = 'A test skill.'
) {
  skill_dir <- fs::path(dir, name)
  fs::dir_create(skill_dir)
  writeLines(
    c(
      '---',
      paste0('name: ', name),
      paste0('description: ', description),
      '---'
    ),
    fs::path(skill_dir, 'SKILL.md')
  )
  skill_dir
}

test_that('list_skills returns empty data frame for nonexistent path', {
  tmp <- withr::local_tempdir()
  result <- list_skills(fs::path(tmp, 'no-skills-here'))
  expect_identical(nrow(result), 0L)
  expect_named(result, c('name', 'description', 'source', 'installed_at'))
})

test_that('list_skills returns empty data frame for empty directory', {
  tmp <- withr::local_tempdir()
  fs::dir_create(fs::path(tmp, 'skills'))
  result <- list_skills(fs::path(tmp, 'skills'))
  expect_identical(nrow(result), 0L)
})

test_that('list_skills returns one row per skill', {
  tmp <- withr::local_tempdir()
  make_fixture_skill(tmp, 'skill-one', 'First skill.')
  make_fixture_skill(tmp, 'skill-two', 'Second skill.')
  result <- list_skills(tmp)
  expect_identical(nrow(result), 2L)
  expect_setequal(result$name, c('skill-one', 'skill-two'))
})

test_that('list_skills includes source and installed_at from lock', {
  tmp <- withr::local_tempdir()
  src <- withr::local_tempdir()
  fixture <- make_fixture_skill(src)
  dest_dir <- fs::path(tmp, 'skills')
  add_skill(fixture, path = dest_dir)

  result <- list_skills(dest_dir)
  expect_identical(nrow(result), 1L)
  expect_identical(result$source, as.character(fs::path_abs(fixture)))
  expect_match(result$installed_at, '^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}Z$')
})
