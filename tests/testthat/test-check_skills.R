make_lock <- function(path, entries) {
  root <- fs::path_dir(path)
  fs::dir_create(root, recurse = TRUE)
  jsonlite::write_json(
    list(skills = entries),
    fs::path(root, '.wf-lock.json'),
    auto_unbox = TRUE,
    pretty = TRUE
  )
}

test_that('check_skills returns empty data frame for empty skills dir', {
  tmp <- withr::local_tempdir()
  result <- check_skills(tmp)
  expect_identical(nrow(result), 0L)
  expect_named(
    result,
    c('name', 'installed_sha', 'latest_sha', 'update_available')
  )
})

test_that('check_skills detects update available when SHAs differ', {
  tmp <- withr::local_tempdir()
  make_lock(
    tmp,
    list(
      `test-skill` = list(
        source = 'https://github.com/owner/test-skill',
        type = 'github',
        sha = 'abc123',
        installed_at = '2026-01-01T00:00:00Z'
      )
    )
  )
  local_mocked_bindings(
    gh_latest_sha = function(owner, repo) 'def456'
  )
  result <- check_skills(tmp)
  expect_identical(nrow(result), 1L)
  expect_identical(result$update_available, TRUE)
  expect_identical(result$installed_sha, 'abc123')
  expect_identical(result$latest_sha, 'def456')
})

test_that('check_skills reports no update when SHAs match', {
  tmp <- withr::local_tempdir()
  make_lock(
    tmp,
    list(
      `test-skill` = list(
        source = 'https://github.com/owner/test-skill',
        type = 'github',
        sha = 'abc123',
        installed_at = '2026-01-01T00:00:00Z'
      )
    )
  )
  local_mocked_bindings(
    gh_latest_sha = function(owner, repo) 'abc123'
  )
  result <- check_skills(tmp)
  expect_identical(result$update_available, FALSE)
})

test_that('check_skills marks local skills as not updatable', {
  tmp <- withr::local_tempdir()
  make_lock(
    tmp,
    list(
      `local-skill` = list(
        source = '/some/local/path',
        type = 'local',
        sha = NULL,
        installed_at = '2026-01-01T00:00:00Z'
      )
    )
  )
  result <- check_skills(tmp)
  expect_identical(result$update_available, FALSE)
  expect_identical(result$latest_sha, NA_character_)
})
