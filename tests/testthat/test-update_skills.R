make_lock <- function(path, entries) {
  fs::dir_create(path, recurse = TRUE)
  jsonlite::write_json(
    entries,
    fs::path(path, '.skill-lock.json'),
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

  called_sources <- character()
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
      called_sources <<- c(called_sources, source)
      invisible(fs::path(path, 'skill-a'))
    }
  )

  result <- update_skills(tmp)
  expect_identical(result, 'skill-a')
  expect_identical(called_sources, 'https://github.com/owner/skill-a')
})

test_that('update_skills does not call add_skill when all are up to date', {
  tmp <- withr::local_tempdir()
  add_skill_called <- FALSE
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
      add_skill_called <<- TRUE
    }
  )

  result <- update_skills(tmp)
  expect_false(add_skill_called)
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
