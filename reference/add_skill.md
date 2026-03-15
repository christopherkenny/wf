# Install a skill

Installs a skill from a GitHub repository or a local directory into a
skills directory.

## Usage

``` r
add_skill(source, skill = NULL, path = NULL, overwrite = FALSE)
```

## Arguments

- source:

  One of:

  - A GitHub URL pointing to a repo, e.g.
    `"https://github.com/owner/repo"`.

  - A GitHub URL pointing to a subdirectory, e.g.
    `"https://github.com/owner/repo/tree/main/path/to/skill"`.

  - A GitHub shorthand, e.g. `"owner/repo"`.

  - A local directory path containing a `SKILL.md` file.

- skill:

  For multi-skill repositories that store skills under a `skills/`
  subdirectory, the name of the skill to install, e.g.
  `skill = "proofread"`. When supplied, the skill is read from
  `skills/<skill>` within the repository. Ignored when `source` already
  points to a specific subdirectory via `/tree/...`.

- path:

  The skills directory to install into. Can be one of:

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

- overwrite:

  If `FALSE` (the default), an error is raised if the skill is already
  installed. Set to `TRUE` to replace it.

## Value

The path to the installed skill directory, invisibly.

## Examples

``` r
src <- tempfile()
dir.create(src)
writeLines(
  c('---', 'name: example', 'description: An example skill.', '---'),
  file.path(src, 'SKILL.md')
)
add_skill(src, path = tempfile())
#> Installed skill "example" to /tmp/RtmpOKMrZj/file1b842416f2c2/example.
```
