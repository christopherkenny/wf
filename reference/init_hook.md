# Create a new hook template

Creates a new shell script hook file at `path/name.sh` containing a
minimal template ready to be filled in. After editing the script,
register it with
[`register_hook()`](https://christophertkenny.com/wf/reference/register_hook.md)
or install it with
[`add_hook()`](https://christophertkenny.com/wf/reference/add_hook.md).

## Usage

``` r
init_hook(name, path = NULL)
```

## Arguments

- name:

  Hook name. Must be 1-64 characters, lowercase alphanumeric with single
  hyphens (no consecutive `--`), and cannot start or end with a hyphen.
  Consider using a kebab-case verb form (e.g. `"lint-on-save"`,
  `"check-format"`).

- path:

  Directory in which to create the hook file. Can be one of:

  - A known coding agent name such as `"claude_code"` or
    `"github_copilot"` to use that agent's conventional project-scope
    path (see
    [`hook_path()`](https://christophertkenny.com/wf/reference/hook_path.md)
    for the full list).

  - A character string giving the directory path directly.

  - `NULL` (the default), in which case the path is resolved from the
    `WF_AGENT` environment variable, or by prompting in interactive
    sessions. Set `WF_AGENT` in your `.Renviron` (e.g. with
    `usethis::edit_r_environ()`) to avoid the prompt.

## Value

The path to the new hook file, invisibly.

## Examples

``` r
init_hook('my-hook', tempfile())
#> Created hook "my-hook" at /tmp/Rtmp1p0v0x/file1be57fd605ed/my-hook.sh.
#> ℹ Register it with `register_hook(event, command =
#>   "/tmp/Rtmp1p0v0x/file1be57fd605ed/my-hook.sh")`
```
