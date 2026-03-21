# Update installed hooks

Checks each installed hook for available updates and re-installs any
that have a newer version on GitHub.

## Usage

``` r
update_hooks(path = NULL, settings = NULL)
```

## Arguments

- path:

  The hooks directory to update. Can be one of:

  - A known coding agent name such as `"claude_code"`, `"cursor"`, or
    `"github_copilot"` (see
    [`hook_path()`](https://christophertkenny.com/wf/reference/hook_path.md)
    for the full list) to use that agent's conventional project-scope
    path.

  - A character string giving the directory path directly.

  - `NULL` (the default), in which case the path is resolved from the
    `WF_AGENT` environment variable, or by prompting in interactive
    sessions. Set `WF_AGENT` in your `.Renviron` (e.g. with
    `usethis::edit_r_environ()`) to avoid the prompt.

- settings:

  Path to the `settings.json` file where hooks are registered. When
  `NULL` (the default), defaults to `settings.json` in the parent
  directory of `path`.

## Value

A character vector of updated hook names, invisibly.

## Examples

``` r
update_hooks(tempfile())
#> All hooks are up to date.
```
