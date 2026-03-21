# List installed skills

Returns a data frame describing all skills installed in a skills
directory.

## Usage

``` r
list_skills(path = NULL)
```

## Arguments

- path:

  The skills directory. Can be one of:

  - A known coding agent name such as `'claude_code'`, `'cursor'`, or
    `'github_copilot'` (see
    [`skill_path()`](https://christophertkenny.com/wf/reference/skill_path.md)
    for the full list) to use that agent's conventional project-scope
    path.

  - A character string giving the directory path directly.

  - `NULL` (the default), in which case the path is resolved from the
    `WF_AGENT` environment variable, or by prompting in interactive
    sessions. Set `WF_AGENT` in your `.Renviron` (e.g. with
    `usethis::edit_r_environ()`) to avoid the prompt.

## Value

A data frame with columns:

- `name`: skill name from frontmatter (or filename stem).

- `description`: skill description from frontmatter.

- `source`: the source URL or local path the skill was installed from.

- `installed_at`: ISO 8601 timestamp of when the skill was installed.

## Examples

``` r
list_skills(tempfile())
#> [1] name         description  source       installed_at
#> <0 rows> (or 0-length row.names)
```
