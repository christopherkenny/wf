# Update installed rules

Checks each installed rule for available updates and re-installs any
that have a newer version on GitHub.

## Usage

``` r
update_rules(path = NULL)
```

## Arguments

- path:

  The rules directory to update. Can be one of:

  - A known coding agent name such as `"claude_code"`, `"cursor"`, or
    `"github_copilot"` (see
    [`rule_path()`](https://christophertkenny.com/wf/reference/rule_path.md)
    for the full list) to use that agent's conventional project-scope
    path.

  - A character string giving the directory path directly.

  - `NULL` (the default), in which case the path is resolved from the
    `WF_AGENT` environment variable, or by prompting in interactive
    sessions. Set `WF_AGENT` in your `.Renviron` (e.g. with
    `usethis::edit_r_environ()`) to avoid the prompt.

## Value

A character vector of updated rule names, invisibly.

## Examples

``` r
update_rules(tempfile())
#> All rules are up to date.
```
