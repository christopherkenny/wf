test_that('hook_path returns project hooks directory', {
  expect_identical(hook_path('claude_code', 'project'), '.claude/hooks')
  expect_identical(hook_path('cursor', 'project'), '.cursor/hooks')
})

test_that('hook_path returns global hooks directory', {
  expect_identical(hook_path('claude_code', 'global'), '~/.claude/hooks')
})

test_that('"claude" alias works for hook_path', {
  expect_identical(hook_path('claude', 'project'), '.claude/hooks')
})

test_that('hook_path errors on unknown agent', {
  expect_snapshot(hook_path('unknown_agent'), error = TRUE)
})

test_that('hook_path uses WF_AGENT env var', {
  withr::with_envvar(c(WF_AGENT = 'cursor'), {
    expect_identical(hook_path(), '.cursor/hooks')
  })
})
