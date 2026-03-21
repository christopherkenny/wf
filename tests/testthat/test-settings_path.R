test_that('settings_path returns project settings path', {
  expect_identical(settings_path('claude_code', 'project'), '.claude/settings.json')
  expect_identical(settings_path('cursor', 'project'), '.cursor/settings.json')
})

test_that('settings_path returns local settings path', {
  expect_identical(
    settings_path('claude_code', 'local'),
    '.claude/settings.local.json'
  )
})

test_that('settings_path returns global settings path', {
  expect_identical(
    settings_path('claude_code', 'global'),
    '~/.claude/settings.json'
  )
})

test_that('"claude" alias works for settings_path', {
  expect_identical(settings_path('claude', 'project'), '.claude/settings.json')
})

test_that('settings_path errors on unknown agent', {
  expect_snapshot(settings_path('unknown_agent'), error = TRUE)
})

test_that('settings_path uses WF_AGENT env var', {
  withr::with_envvar(c(WF_AGENT = 'cursor'), {
    expect_identical(settings_path(), '.cursor/settings.json')
  })
})
