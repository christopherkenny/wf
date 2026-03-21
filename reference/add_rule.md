# Install a rule

Installs a rule from a GitHub repository or a local file into a rules
directory. Rules are Markdown files with optional YAML frontmatter. The
rule `name` comes from the frontmatter if present, otherwise from the
filename stem.

## Usage

``` r
add_rule(source, rule = NULL, path = NULL, overwrite = FALSE)
```

## Arguments

- source:

  One of:

  - A GitHub URL pointing to a repo, e.g.
    `"https://github.com/owner/repo"`.

  - A GitHub URL pointing to a subdirectory or file, e.g.
    `"https://github.com/owner/repo/tree/main/path/to/rule.md"`.

  - A GitHub shorthand, e.g. `"owner/repo"`.

  - A local file path pointing to a Markdown file.

- rule:

  For multi-rule repositories that store rules under a `rules/`
  subdirectory, the name of the rule to install (without the `.md`
  extension), e.g. `rule = "testing"`. When supplied, the rule is read
  from `rules/<rule>.md` within the repository. Ignored when `source`
  already points to a specific path via `/tree/...`.

- path:

  The rules directory. Can be one of:

  - A known coding agent name such as `'claude_code'`, `'cursor'`, or
    `'github_copilot'` (see
    [`rule_path()`](https://christophertkenny.com/wf/reference/rule_path.md)
    for the full list) to use that agent's conventional project-scope
    path.

  - A character string giving the directory path directly.

  - `NULL` (the default), in which case the path is resolved from the
    `WF_AGENT` environment variable, or by prompting in interactive
    sessions. Set `WF_AGENT` in your `.Renviron` (e.g. with
    `usethis::edit_r_environ()`) to avoid the prompt.

- overwrite:

  If `FALSE` (the default), an error is raised if the rule is already
  installed. Set to `TRUE` to replace it.

## Value

The path to the installed rule file, invisibly.

## Examples

``` r
src <- tempfile(fileext = '.md')
writeLines(
  c('---', 'name: example', 'description: An example rule.', '---'),
  src
)
add_rule(src, path = tempfile())
#> Installed rule "example" to /tmp/Rtmp1p0v0x/file1be54023fa66/example.md.
```
