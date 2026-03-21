# Register a hook command in the settings file

Adds a shell command hook to a coding agent's `settings.json` file.
Hooks run automatically on agent events such as `"PreToolUse"` or
`"UserPromptSubmit"`. To install a hook script from GitHub or a local
file, use
[`add_hook()`](https://christophertkenny.com/wf/reference/add_hook.md)
instead.

## Usage

``` r
register_hook(
  event,
  command,
  matcher = NULL,
  timeout = NULL,
  async = FALSE,
  agent = NULL,
  scope = c("project", "local", "global"),
  path = NULL
)
```

## Arguments

- event:

  The lifecycle event to attach the hook to. One of `"PreToolUse"`,
  `"PostToolUse"`, `"UserPromptSubmit"`, `"Stop"`, or `"SubagentStop"`.

- command:

  The shell command to execute when the hook fires.

- matcher:

  An optional tool-name pattern (for `"PreToolUse"` and `"PostToolUse"`
  events) used to filter which tool calls trigger the hook, e.g.
  `"Bash|Edit"`. When `NULL` (the default), the hook applies to all tool
  calls for the event.

- timeout:

  Optional timeout in seconds for the hook command.

- async:

  If `TRUE`, the hook runs asynchronously and the agent does not wait
  for it to complete. Default is `FALSE`.

- agent, scope, path:

  Passed to
  [`settings_path()`](https://christophertkenny.com/wf/reference/settings_path.md)
  to locate the settings file. Defaults resolve to the project-scope
  settings of the detected coding agent.

## Value

The path to the modified settings file, invisibly.

## Examples

``` r
tmp <- tempfile(fileext = '.json')
register_hook('PreToolUse', 'echo hello', path = tmp)
#> Registered PreToolUse hook in /tmp/Rtmp1p0v0x/file1be522de2651.json.
```
