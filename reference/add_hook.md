# Install a hook script

Installs a hook script from a GitHub repository or a local file into a
hooks directory, then registers it in the corresponding `settings.json`
so it runs on the specified lifecycle event.

## Usage

``` r
add_hook(
  source,
  event,
  hook = NULL,
  matcher = NULL,
  path = NULL,
  settings = NULL,
  overwrite = FALSE,
  timeout = NULL,
  async = FALSE
)
```

## Arguments

- source:

  One of:

  - A GitHub URL pointing to a repo, e.g.
    `"https://github.com/owner/repo"`.

  - A GitHub shorthand, e.g. `"owner/repo"`.

  - A local file path pointing to an executable script (`.sh`, `.R`,
    `.py`, etc.).

- event:

  The lifecycle event to attach the hook to. One of `"PreToolUse"`,
  `"PostToolUse"`, `"UserPromptSubmit"`, `"Stop"`, or `"SubagentStop"`.

- hook:

  For multi-hook repositories that store scripts under a `hooks/`
  subdirectory, the name of the hook to install (without the file
  extension), e.g. `hook = "lint-staged"`. When supplied, the script is
  read from `hooks/<hook>.<ext>` within the repository. Ignored when
  `source` already points to a specific file.

- matcher:

  An optional tool-name pattern (for `"PreToolUse"` and `"PostToolUse"`
  events) used to filter which tool calls trigger the hook, e.g.
  `"Bash|Edit"`. When `NULL` (the default), the hook applies to all tool
  calls for the event.

- path:

  The hooks directory. Can be one of:

  - A known coding agent name such as `'claude_code'`, `'cursor'`, or
    `'github_copilot'` (see
    [`hook_path()`](https://christophertkenny.com/wf/reference/hook_path.md)
    for the full list) to use that agent's conventional project-scope
    path.

  - A character string giving the directory path directly.

  - `NULL` (the default), in which case the path is resolved from the
    `WF_AGENT` environment variable, or by prompting in interactive
    sessions. Set `WF_AGENT` in your `.Renviron` (e.g. with
    `usethis::edit_r_environ()`) to avoid the prompt.

- settings:

  Path to the `settings.json` file where the hook will be registered.
  When `NULL` (the default), defaults to `settings.json` in the parent
  directory of `path` (e.g. if `path` is `.claude/hooks`, uses
  `.claude/settings.json`).

- overwrite:

  If `FALSE` (the default), an error is raised if the hook is already
  installed. Set to `TRUE` to replace it.

- timeout:

  Optional timeout in seconds for the hook command.

- async:

  If `TRUE`, the hook runs asynchronously. Default is `FALSE`.

## Value

The path to the installed hook script, invisibly.

## Examples

``` r
tmp_hook <- tempfile(fileext = '.sh')
writeLines(c('#!/bin/bash', 'echo hello'), tmp_hook)
tmp_dir <- tempfile()
tmp_settings <- tempfile(fileext = '.json')
add_hook(tmp_hook,
  event = 'PreToolUse', path = tmp_dir,
  settings = tmp_settings
)
#> Registered PreToolUse hook in /tmp/Rtmp1p0v0x/file1be560b6bb66.json.
#> Installed hook "file1be52472354c" to
#> /tmp/Rtmp1p0v0x/file1be568d31454/file1be52472354c.sh.
```
