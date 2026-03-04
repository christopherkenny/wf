# List installed skills

Returns a data frame describing all skills installed in a skills
directory.

## Usage

``` r
list_skills(path = skill_path())
```

## Arguments

- path:

  The skills directory to inspect. Defaults to
  [`skill_path()`](https://christopherkenny.github.io/wf/reference/skill_path.md),
  which resolves the agent from `WF_AGENT`, a directory scan, or falls
  back to `"claude_code"`.

## Value

A data frame with columns:

- `name`: skill name from `SKILL.md` frontmatter.

- `description`: skill description from `SKILL.md` frontmatter.

- `source`: the source URL or local path the skill was installed from.

- `installed_at`: ISO 8601 timestamp of when the skill was installed.

## Examples

``` r
list_skills(tempfile())
#> [1] name         description  source       installed_at
#> <0 rows> (or 0-length row.names)
```
