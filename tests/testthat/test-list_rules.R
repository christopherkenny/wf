test_that('list_rules returns empty data frame for missing directory', {
  result <- list_rules(tempfile())
  expect_s3_class(result, 'data.frame')
  expect_named(result, c('name', 'description', 'source', 'installed_at'))
  expect_identical(nrow(result), 0L)
})

test_that('list_rules returns one row per installed rule', {
  tmp <- withr::local_tempdir()
  src <- withr::local_tempdir()
  for (nm in c('rule-a', 'rule-b')) {
    writeLines(
      c('---', paste0('name: ', nm), paste0('description: Rule ', nm, '.'), '---'),
      fs::path(src, paste0(nm, '.md'))
    )
    add_rule(fs::path(src, paste0(nm, '.md')), path = tmp)
  }

  result <- list_rules(tmp)
  expect_identical(nrow(result), 2L)
})

test_that('list_rules falls back to filename stem for no-frontmatter rules', {
  tmp <- withr::local_tempdir()
  writeLines(c('# A rule'), fs::path(tmp, 'plain.md'))

  result <- list_rules(tmp)
  expect_identical(result$name[[1]], 'plain')
  expect_true(is.na(result$description[[1]]))
})
