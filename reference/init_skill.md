# Create a new skill template

Creates a new skill directory at `path/name/` containing a template
`SKILL.md` file ready to be filled in.

## Usage

``` r
init_skill(name, path)
```

## Arguments

- name:

  Skill name. Must be 1-64 characters, lowercase alphanumeric with
  single hyphens (no consecutive `--`), and cannot start or end with a
  hyphen. Consider using a gerund form (e.g. `"parsing-logs"`).

- path:

  Directory in which to create the skill. The skill directory itself
  will be `path/name`. Can be a known agent name such as `"claude_code"`
  or `"github_copilot"` to use that agent's conventional project-scope
  path (see
  [`skill_path()`](https://christopherkenny.github.io/wf/reference/skill_path.md)
  for the full list).

## Value

The path to the new skill directory, invisibly.

## Examples

``` r
init_skill('my-skill', tempfile())
#> Created skill "my-skill" at /tmp/Rtmp8TN0Ay/file19ca2f971634/my-skill.
```
