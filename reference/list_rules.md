# List installed rules

Returns a data frame describing all rules installed in a rules
directory.

## Usage

``` r
list_rules(path = NULL)
```

## Arguments

- path:

  The rules directory. Can be one of:

  - A known coding agent name such as `'claude_code'`, `'cursor'`, or
    `'github_copilot'` (see
    [`rule_path()`](https://christophertkenny.com/wf/reference/rule_path.md)
    for the full list) to use that agent's conventional project-scope
    path.

  - A character string giving the directory path directly.

  - `NULL` (the default), in which case the path is resolved from the
    `WF_AGENT` environment variable, or by prompting in interactive
    sessions. Set `WF_AGENT` in your `.Renviron` (e.g. with
    `usethis::edit_r_environ()`) to avoid the prompt.

## Value

A data frame with columns:

- `name`: rule name from frontmatter (or filename stem).

- `description`: rule description from frontmatter.

- `source`: the source URL or local path the rule was installed from.

- `installed_at`: ISO 8601 timestamp of when the rule was installed.

## Examples

``` r
list_rules(tempfile())
#> [1] name         description  source       installed_at
#> <0 rows> (or 0-length row.names)
```
