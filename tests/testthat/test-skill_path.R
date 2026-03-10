test_that('skill_path returns correct project paths', {
  expect_identical(skill_path('claude_code', 'project'), '.claude/skills')
  expect_identical(skill_path('openclaw', 'project'), '.openclaw/skills')
  expect_identical(skill_path('codex', 'project'), '.codex/skills')
  expect_identical(skill_path('cursor', 'project'), '.cursor/skills')
  expect_identical(skill_path('gemini_cli', 'project'), '.gemini/skills')
  expect_identical(skill_path('github_copilot', 'project'), '.copilot/skills')
})

test_that('skill_path returns correct global paths', {
  expect_identical(skill_path('claude_code', 'global'), '~/.claude/skills')
  expect_identical(skill_path('cursor', 'global'), '~/.cursor/skills')
  expect_identical(skill_path('github_copilot', 'global'), '~/.copilot/skills')
})

test_that('skill_path defaults to project scope', {
  expect_identical(skill_path('claude_code'), '.claude/skills')
})

test_that('skill_path errors on unknown agent', {
  expect_snapshot(skill_path('unknown_agent'), error = TRUE)
})

test_that('skill_path errors on unknown scope', {
  expect_snapshot(skill_path('claude_code', 'workspace'), error = TRUE)
})

test_that('"claude" is an alias for claude_code', {
  expect_identical(skill_path('claude', 'project'), '.claude/skills')
  expect_identical(skill_path('claude', 'global'), '~/.claude/skills')
})

test_that('skill_path detects agent from directory', {
  tmp <- withr::local_tempdir()
  dir.create(file.path(tmp, '.cursor'))
  withr::with_dir(tmp, {
    withr::with_envvar(c(WF_AGENT = ''), {
      expect_identical(skill_path(), '.cursor/skills')
    })
  })
})

test_that('skill_path falls back to claude_code when no agent dir detected', {
  tmp <- withr::local_tempdir()
  withr::with_dir(tmp, {
    withr::with_envvar(c(WF_AGENT = ''), {
      expect_identical(skill_path(), '.claude/skills')
    })
  })
})

test_that('WF_AGENT takes priority over directory detection', {
  tmp <- withr::local_tempdir()
  dir.create(file.path(tmp, '.cursor'))
  withr::with_dir(tmp, {
    withr::with_envvar(c(WF_AGENT = 'codex'), {
      expect_identical(skill_path(), '.codex/skills')
    })
  })
})

test_that('skill_path uses WF_AGENT env var when agent is NULL', {
  withr::with_envvar(c(WF_AGENT = 'cursor'), {
    expect_identical(skill_path(), '.cursor/skills')
  })
})

test_that('skill_path falls back to claude_code when WF_AGENT is unset', {
  withr::with_envvar(c(WF_AGENT = ''), {
    expect_identical(skill_path(), '.claude/skills')
  })
})

test_that('explicit agent overrides WF_AGENT', {
  withr::with_envvar(c(WF_AGENT = 'cursor'), {
    expect_identical(skill_path('codex'), '.codex/skills')
  })
})

test_that('skill_path errors when WF_AGENT is invalid', {
  withr::with_envvar(c(WF_AGENT = 'unknown_agent'), {
    expect_snapshot(skill_path(), error = TRUE)
  })
})

test_that('resolve_path returns project path for known agent name', {
  expect_identical(wf:::resolve_path('claude_code'), '.claude/skills')
  expect_identical(wf:::resolve_path('github_copilot'), '.copilot/skills')
  expect_identical(wf:::resolve_path('cursor'), '.cursor/skills')
})

test_that('resolve_path handles agent aliases', {
  expect_identical(wf:::resolve_path('claude'), '.claude/skills')
})

test_that('resolve_path returns literal path for unknown string', {
  expect_identical(wf:::resolve_path('/tmp/my/skills'), '/tmp/my/skills')
  expect_identical(wf:::resolve_path('some/custom/path'), 'some/custom/path')
})

test_that('resolve_path uses WF_AGENT when path is NULL', {
  withr::with_envvar(c(WF_AGENT = 'cursor'), {
    expect_identical(wf:::resolve_path(NULL), '.cursor/skills')
  })
})

test_that('resolve_path aborts when path is NULL and no env var set', {
  tmp <- withr::local_tempdir()
  withr::with_dir(tmp, {
    withr::with_envvar(c(WF_AGENT = ''), {
      expect_snapshot(wf:::resolve_path(NULL), error = TRUE)
    })
  })
})
