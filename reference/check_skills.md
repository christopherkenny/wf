# Check installed skills for available updates

Compares each installed skill's recorded commit SHA against the latest
commit on GitHub. Local skills are reported as not updatable.

## Usage

``` r
check_skills(path = NULL)
```

## Arguments

- path:

  The skills directory to check. Can be one of:

  - A known agent name such as `"claude_code"`, `"cursor"`, or
    `"github_copilot"` (see
    [`skill_path()`](https://christopherkenny.github.io/wf/reference/skill_path.md)
    for the full list) to use that agent's conventional project-scope
    path.

  - A character string giving the directory path directly.

  - `NULL` (the default), in which case the path is resolved from the
    `WF_AGENT` environment variable, or by prompting in interactive
    sessions. Set `WF_AGENT` in your `.Renviron` (e.g. with
    `usethis::edit_r_environ()`) to avoid the prompt.

## Value

A data frame with columns:

- `name`: skill name.

- `installed_sha`: the SHA recorded at install time (`NA` for local).

- `latest_sha`: the current HEAD SHA on GitHub (`NA` for local or on
  network failure).

- `update_available`: `TRUE` if installed and latest SHAs differ.

## Examples

``` r
check_skills(tempfile())
#> [1] name             installed_sha    latest_sha       update_available
#> <0 rows> (or 0-length row.names)
```
