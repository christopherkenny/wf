# List hooks in a settings file

Returns a data frame of all hooks configured in a coding agent's
`settings.json` file.

## Usage

``` r
list_hooks(
  path = NULL,
  settings = NULL,
  agent = NULL,
  scope = c("project", "local", "global")
)
```

## Arguments

- path:

  The hooks directory. When supplied, the `file` column in the returned
  data frame will contain the path to the installed script file for
  hooks that were installed with
  [`add_hook()`](https://christophertkenny.com/wf/reference/add_hook.md).
  Can be one of:

  - A known coding agent name to use that agent's conventional hooks
    path.

  - A character string giving the directory path directly.

  - `NULL` (the default), in which case `file` will be `NA` for all
    rows.

- settings:

  Path to the `settings.json` file to read. When `NULL` (the default),
  resolved from `agent`, `scope`, and the `WF_AGENT` environment
  variable.

- agent, scope:

  Passed to
  [`settings_path()`](https://christophertkenny.com/wf/reference/settings_path.md)
  to locate the settings file when `settings` is `NULL`. Defaults
  resolve to the project-scope settings of the detected coding agent.

## Value

A data frame with columns:

- `event`: the lifecycle event name (e.g. `"PreToolUse"`).

- `matcher`: the tool-name pattern, or `NA` if none.

- `command`: the shell command to execute.

- `file`: path to the installed script file, or `NA` if not tracked.

## Examples

``` r
tmp <- tempfile(fileext = '.json')
register_hook('PreToolUse', 'echo hello', path = tmp)
#> Registered PreToolUse hook in /tmp/Rtmp1p0v0x/file1be57e5281b4.json.
list_hooks(settings = tmp)
#>        event matcher    command file
#> 1 PreToolUse    <NA> echo hello <NA>
```
