# Get the conventional skill path for an agent

Returns the conventional directory path where skills for a given agent
are stored. The path is not expanded (i.e., `~` is not resolved to the
home directory). Use
[`base::path.expand()`](https://rdrr.io/r/base/path.expand.html) if you
need an absolute path.

## Usage

``` r
skill_path(agent = NULL, scope = c("project", "global"))
```

## Arguments

- agent:

  One of `"claude_code"` (or its alias `"claude"`), `"openclaw"`,
  `"codex"`, `"cursor"`, `"gemini_cli"`, `"github_copilot"`, or
  `"posit_ai"` (or its alias `"posit"`). If `NULL` (the default), the
  agent is resolved in order: (1) the `WF_AGENT` environment
  variable, (2) a scan of the current working directory for a recognised
  agent config folder (`.claude`, `.cursor`, etc.), and (3) a final
  fallback to `"claude_code"`. Set `WF_AGENT` in your `.Renviron` (e.g.
  with `usethis::edit_r_environ()`) to avoid passing `agent` every time.

- scope:

  One of `"project"` (a path relative to the current working directory,
  suitable for committing to version control) or `"global"` (a path in
  the user's home directory, available across all projects).

## Value

A length-1 character vector giving the conventional skill path.

## Examples

``` r
skill_path('claude_code', 'project')
#> [1] ".claude/skills"
skill_path('claude', 'project') # alias for claude_code
#> [1] ".claude/skills"
skill_path('posit_ai', 'project')
#> [1] ".positai/skills"
skill_path('posit', 'project') # alias for posit_ai
#> [1] ".positai/skills"
skill_path('cursor', 'global')
#> [1] "~/.cursor/skills"
skill_path() # auto-detects from WF_AGENT, dir scan, or falls back to claude_code
#> [1] ".claude/skills"
```
