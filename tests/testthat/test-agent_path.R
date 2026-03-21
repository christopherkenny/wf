test_that('agent_path returns correct project paths', {
  expect_identical(agent_path('claude_code', 'project'), '.claude/agents')
  expect_identical(agent_path('openclaw', 'project'), '.openclaw/agents')
  expect_identical(agent_path('codex', 'project'), '.codex/agents')
  expect_identical(agent_path('cursor', 'project'), '.cursor/agents')
  expect_identical(agent_path('gemini_cli', 'project'), '.gemini/agents')
  expect_identical(agent_path('github_copilot', 'project'), '.copilot/agents')
  expect_identical(agent_path('posit_ai', 'project'), '.positai/agents')
})

test_that('agent_path returns correct global paths', {
  expect_identical(agent_path('claude_code', 'global'), '~/.claude/agents')
  expect_identical(agent_path('cursor', 'global'), '~/.cursor/agents')
  expect_identical(agent_path('github_copilot', 'global'), '~/.copilot/agents')
})

test_that('agent_path defaults to project scope', {
  expect_identical(agent_path('claude_code'), '.claude/agents')
})

test_that('agent_path errors on unknown agent', {
  expect_snapshot(agent_path('unknown_agent'), error = TRUE)
})

test_that('agent_path errors on unknown scope', {
  expect_snapshot(agent_path('claude_code', 'workspace'), error = TRUE)
})

test_that('"claude" alias works for agent_path', {
  expect_identical(agent_path('claude', 'project'), '.claude/agents')
  expect_identical(agent_path('claude', 'global'), '~/.claude/agents')
})

test_that('"copilot" alias works for agent_path', {
  expect_identical(agent_path('copilot', 'project'), '.copilot/agents')
})

test_that('agent_path uses WF_AGENT env var', {
  withr::with_envvar(c(WF_AGENT = 'cursor'), {
    expect_identical(agent_path(), '.cursor/agents')
  })
})

test_that('agent_path detects agent from directory', {
  tmp <- withr::local_tempdir()
  dir.create(file.path(tmp, '.cursor'))
  withr::with_dir(tmp, {
    withr::with_envvar(c(WF_AGENT = ''), {
      expect_identical(agent_path(), '.cursor/agents')
    })
  })
})

test_that('agent_path falls back to claude_code when no agent detected', {
  tmp <- withr::local_tempdir()
  withr::with_dir(tmp, {
    withr::with_envvar(c(WF_AGENT = ''), {
      expect_identical(agent_path(), '.claude/agents')
    })
  })
})
