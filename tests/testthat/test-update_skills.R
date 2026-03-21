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

test_that('update_skills calls add_skill for each skill with an update', {
  tmp <- withr::local_tempdir()
  make_lock(
    tmp,
    list(
      `skill-a` = list(
        source = 'https://github.com/owner/skill-a',
        type = 'github',
        sha = 'old123',
        installed_at = '2026-01-01T00:00:00Z'
      )
    )
  )

  local_mocked_bindings(
    check_skills = function(path) {
      data.frame(
        name = 'skill-a',
        installed_sha = 'old123',
        latest_sha = 'new456',
        update_available = TRUE,
        stringsAsFactors = FALSE
      )
    },
    add_skill = function(source, path, overwrite) {
      expect_identical(source, 'https://github.com/owner/skill-a')
      invisible(fs::path(path, 'skill-a'))
    }
  )

  result <- update_skills(tmp)
  expect_identical(result, 'skill-a')
})

test_that('update_skills does not call add_skill when all are up to date', {
  tmp <- withr::local_tempdir()
  local_mocked_bindings(
    check_skills = function(path) {
      data.frame(
        name = 'skill-a',
        installed_sha = 'abc123',
        latest_sha = 'abc123',
        update_available = FALSE,
        stringsAsFactors = FALSE
      )
    },
    add_skill = function(source, path, overwrite) {
      stop('add_skill should not be called when all skills are up to date')
    }
  )

  result <- update_skills(tmp)
  expect_identical(result, character())
})

test_that('update_skills returns invisibly', {
  tmp <- withr::local_tempdir()
  local_mocked_bindings(
    check_skills = function(path) {
      data.frame(
        name = character(),
        installed_sha = character(),
        latest_sha = character(),
        update_available = logical(),
        stringsAsFactors = FALSE
      )
    }
  )
  expect_invisible(update_skills(tmp))
})
