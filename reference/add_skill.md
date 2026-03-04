# Install a skill

Installs a skill from a GitHub repository or a local directory into a
skills directory.

## Usage

``` r
add_skill(source, path = skill_path(), skill = NULL, overwrite = FALSE)
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

- path:

  The skills directory to install into. Defaults to
  [`skill_path()`](https://christopherkenny.github.io/wf/reference/skill_path.md),
  which resolves the agent from `WF_AGENT`, a directory scan, or falls
  back to `"claude_code"`.

- skill:

  For multi-skill repositories that store skills under a `skills/`
  subdirectory, the name of the skill to install, e.g.
  `skill = "proofread"`. When supplied, the skill is read from
  `skills/<skill>` within the repository. Ignored when `source` already
  points to a specific subdirectory via `/tree/...`.

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
add_skill(src, tempfile())
#> Installed skill "example" to /tmp/RtmpDH8Q3B/file19db5678a43d/example.
```
