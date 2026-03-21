test_that('rule_path returns correct project paths', {
  expect_identical(rule_path('claude_code', 'project'), '.claude/rules')
  expect_identical(rule_path('cursor', 'project'), '.cursor/rules')
  expect_identical(rule_path('github_copilot', 'project'), '.copilot/rules')
})

test_that('rule_path returns correct global paths', {
  expect_identical(rule_path('claude_code', 'global'), '~/.claude/rules')
  expect_identical(rule_path('cursor', 'global'), '~/.cursor/rules')
})

test_that('rule_path defaults to project scope', {
  expect_identical(rule_path('claude_code'), '.claude/rules')
})

test_that('rule_path errors on unknown agent', {
  expect_snapshot(rule_path('unknown_agent'), error = TRUE)
})

test_that('"claude" alias works for rule_path', {
  expect_identical(rule_path('claude', 'project'), '.claude/rules')
})

test_that('rule_path uses WF_AGENT env var', {
  withr::with_envvar(c(WF_AGENT = 'cursor'), {
    expect_identical(rule_path(), '.cursor/rules')
  })
})

test_that('rule_path falls back to claude_code when no agent detected', {
  tmp <- withr::local_tempdir()
  withr::with_dir(tmp, {
    withr::with_envvar(c(WF_AGENT = ''), {
      expect_identical(rule_path(), '.claude/rules')
    })
  })
})
