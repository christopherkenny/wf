# Get the path to a coding agent's settings file

Returns the path to the `settings.json` file where hooks are configured
for a given coding agent and scope. The path is not expanded (i.e., `~`
is not resolved to the home directory). Use
[`fs::path_expand()`](https://fs.r-lib.org/reference/path_expand.html)
if you need an absolute path.

## Usage

``` r
settings_path(agent = NULL, scope = c("project", "local", "global"))
```

## Arguments

- agent:

  One of `"claude_code"` (or its alias `"claude"`), `"openclaw"`,
  `"codex"`, `"cursor"`, `"gemini_cli"`, `"github_copilot"` (or its
  alias `"copilot"`), or `"posit_ai"` (or its alias `"posit"`). If
  `NULL` (the default), the agent is resolved in order: (1) the
  `WF_AGENT` environment variable, (2) a scan of the current working
  directory for a recognised agent config folder (`.claude`, `.cursor`,
  etc.), and (3) a final fallback to `"claude_code"`. Set `WF_AGENT` in
  your `.Renviron` (e.g. with `usethis::edit_r_environ()`) to avoid
  passing `agent` every time.

- scope:

  One of:

  - `"project"`: `.{agent}/settings.json` in the current directory.

  - `"local"`: `.{agent}/settings.local.json` (gitignored, for personal
    overrides).

  - `"global"`: `~/.{agent}/settings.json`.

## Value

A length-1 character vector giving the path to the settings file.

## Examples

``` r
settings_path('claude_code', 'project')
#> [1] ".claude/settings.json"
settings_path('claude', 'local') # alias for claude_code
#> [1] ".claude/settings.local.json"
settings_path('cursor', 'global')
#> [1] "~/.cursor/settings.json"
```
