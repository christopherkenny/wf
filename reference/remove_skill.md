# Remove an installed skill

Deletes a skill directory from a skills directory and removes it from
the lock file.

## Usage

``` r
remove_skill(name, path = skill_path(), force = FALSE)
```

## Arguments

- name:

  The name of the skill to remove.

- path:

  The skills directory where the skill is installed. Defaults to
  [`skill_path()`](https://christopherkenny.github.io/wf/reference/skill_path.md),
  which resolves the agent from `WF_AGENT`, a directory scan, or falls
  back to `"claude_code"`.

- force:

  If `FALSE` (the default), prompts for confirmation in interactive
  sessions. Set to `TRUE` to skip the prompt.

## Value

The name of the removed skill, invisibly.

## Examples

``` r
src <- tempfile()
dir.create(src)
writeLines(
  c('---', 'name: example', 'description: An example skill.', '---'),
  file.path(src, 'SKILL.md')
)
tmp <- tempfile()
add_skill(src, tmp)
#> Installed skill "example" to /tmp/RtmpDH8Q3B/file19db5fbcda61/example.
remove_skill('example', tmp, force = TRUE)
#> Removed skill "example" from /tmp/RtmpDH8Q3B/file19db5fbcda61.
```
