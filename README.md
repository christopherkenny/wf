
<!-- README.md is generated from README.Rmd. Please edit that file -->

# wf

<!-- badges: start -->

<!-- badges: end -->

`wf` is an R package for managing AI coding agent **skills**. Skills are
reusable instruction sets that extend what agents, like Claude Code, can
do in your projects.

A skill is a directory containing a `SKILL.md` file with YAML
frontmatter and markdown instructions. Skills live in a conventional
location for each agent (e.g., `.claude/skills/` for Claude Code) and
can be shared, version controlled, and discovered on GitHub.

## Installation

``` r
# install.packages('pak')
pak::pak('christopherkenny/wf')
```

## Getting started

### Tell `wf` which agent you use

Most users work with a single agent. Set `WF_AGENT` in your `.Renviron`
once and every `wf` function will pick it up automatically:

``` r
usethis::edit_r_environ()
```

Then add:

``` r
WF_AGENT='claude_code'
```

Supported agents: `'claude_code'` (alias: `'claude'`), `'openclaw'`,
`'codex'`, `'cursor'`, `'gemini_cli'`, `'github_copilot'`.

If `WF_AGENT` is not set, wf scans the current directory for a
recognized agent config folder (`.claude`, `.cursor`, etc.) and falls
back to `'claude_code'` if none is found.

### Find the skills directory for your agent

``` r
library(wf)

skill_path('claude_code', 'project') # project-local
#> [1] ".claude/skills"
skill_path('claude_code', 'global') # user-global
#> [1] "~/.claude/skills"
skill_path() # auto-detected from WF_AGENT or directory
#> [1] ".claude/skills"
```

## Installing skills

Install a skill from GitHub using its `owner/repo` shorthand or a full
URL:

``` r
add_skill('some-user/some-skill', skill_path())
```

Install from a local directory (useful for skills you are developing):

``` r
add_skill('path/to/my-skill', skill_path())
```

## Listing installed skills

``` r
list_skills(skill_path('claude_code', 'project'))
#>                                                           name
#> .claude/skills/tidy-argument-checking              types-check
#> .claude/skills/tidy-deprecate-function tidy-deprecate-function
#>                                                                                                                                                                                                                                                             description
#> .claude/skills/tidy-argument-checking  Validate function inputs in R using a standalone file of check_* functions. Use when writing exported R functions that need input validation, reviewing existing validation code, or when creating new input validation helpers.
#> .claude/skills/tidy-deprecate-function                    Guide for deprecating R functions/arguments. Use when a user asks to deprecate a function or parameter, including adding lifecycle warnings, updating documentation, adding NEWS entries, and updating tests.
#>                                        source installed_at
#> .claude/skills/tidy-argument-checking    <NA>         <NA>
#> .claude/skills/tidy-deprecate-function   <NA>         <NA>
```

## Checking for updates

``` r
check_skills(skill_path('claude_code', 'project'))
#> [1] name             installed_sha    latest_sha       update_available
#> <0 rows> (or 0-length row.names)
```

## Updating skills

``` r
update_skills(skill_path())
```

## Removing a skill

``` r
remove_skill('skill-name', skill_path(), force = TRUE)
```

## Finding skills on GitHub

Repositories tagged with the `claude-skill` topic are discoverable via
`find_skill()`:

``` r
find_skill()               # all skills
find_skill('typescript')   # filtered by keyword
```

## Creating a new skill

Scaffold a new skill directory with a template `SKILL.md`:

``` r
tmp <- tempfile()
init_skill('my-skill', tmp)
#> Created skill "my-skill" at
#> 'C:/Users/chris/AppData/Local/Temp/RtmpgDY6RP/filee75464a741b5/my-skill'.
```

The generated `SKILL.md` looks like this:

``` yaml
---
name: my-skill
description: >
  What this skill does and when to use it.
---

# My skill

Add your skill instructions here.
```

Fill in the description and instructions, then install it with
`add_skill()`.

## Project vs. global skills

Each agent supports two scopes:

| Scope | Location | Use case |
|----|----|----|
| `'project'` | `.agent/skills/` in the project root | Commit alongside your code; scoped to this project |
| `'global'` | `~/.agent/skills/` in the home directory | Available in every project on this machine |

``` r
# Install a skill globally
add_skill('some-user/some-skill', skill_path(scope = 'global'))
```
