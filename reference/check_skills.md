# Check installed skills for available updates

Compares each installed skill's recorded commit SHA against the latest
commit on GitHub. Local skills are reported as not updatable.

## Usage

``` r
check_skills(path = skill_path())
```

## Arguments

- path:

  The skills directory to check. Defaults to
  [`skill_path()`](https://christopherkenny.github.io/wf/reference/skill_path.md),
  which resolves the agent from `WF_AGENT`, a directory scan, or falls
  back to `"claude_code"`.

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
