# Update installed skills

Checks each installed skill for available updates and re-installs any
that have a newer version on GitHub.

## Usage

``` r
update_skills(path = NULL)
```

## Arguments

- path:

  The skills directory to update. Can be one of:

  - A known agent name such as `"claude_code"`, `"cursor"`, or
    `"github_copilot"` (see
    [`skill_path()`](https://christophertkenny.com/wf/reference/skill_path.md)
    for the full list) to use that agent's conventional project-scope
    path.

  - A character string giving the directory path directly.

  - `NULL` (the default), in which case the path is resolved from the
    `WF_AGENT` environment variable, or by prompting in interactive
    sessions. Set `WF_AGENT` in your `.Renviron` (e.g. with
    `usethis::edit_r_environ()`) to avoid the prompt.

## Value

A character vector of updated skill names, invisibly.

## Examples

``` r
update_skills(tempfile())
#> All skills are up to date.
```
