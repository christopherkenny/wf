# Remove an installed skill

Deletes a skill directory from a skills directory and removes it from
the lock file.

## Usage

``` r
remove_skill(name, path = NULL, force = FALSE)
```

## Arguments

- name:

  The name of the skill to remove.

- path:

  The skills directory where the skill is installed. Can be one of:

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
add_skill(src, path = tmp)
#> Installed skill "example" to /tmp/RtmpfpxO5G/file1be13fea7fc7/example.
remove_skill('example', tmp, force = TRUE)
#> Removed skill "example" from /tmp/RtmpfpxO5G/file1be13fea7fc7.
```
