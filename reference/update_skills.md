# Update installed skills

Checks each installed skill for available updates and re-installs any
that have a newer version on GitHub.

## Usage

``` r
update_skills(path = skill_path())
```

## Arguments

- path:

  The skills directory to update. Defaults to
  [`skill_path()`](https://christopherkenny.github.io/wf/reference/skill_path.md),
  which resolves the agent from `WF_AGENT`, a directory scan, or falls
  back to `"claude_code"`.

## Value

A character vector of updated skill names, invisibly.

## Examples

``` r
update_skills(tempfile())
#> All skills are up to date.
```
