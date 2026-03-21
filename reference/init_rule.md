# Create a new rule template

Creates a new rule file at `path/name.md` containing a template ready to
be filled in.

## Usage

``` r
init_rule(name, path = NULL)
```

## Arguments

- name:

  Rule name. Must be 1-64 characters, lowercase alphanumeric with single
  hyphens (no consecutive `--`), and cannot start or end with a hyphen.
  Consider a descriptive noun form (e.g. `"testing"`, `"code-style"`).

- path:

  Directory in which to create the rule file. Can be one of:

  - A known coding agent name such as `"claude_code"` or
    `"github_copilot"` to use that agent's conventional project-scope
    path (see
    [`rule_path()`](https://christophertkenny.com/wf/reference/rule_path.md)
    for the full list).

  - A character string giving the directory path directly.

  - `NULL` (the default), in which case the path is resolved from the
    `WF_AGENT` environment variable, or by prompting in interactive
    sessions. Set `WF_AGENT` in your `.Renviron` (e.g. with
    `usethis::edit_r_environ()`) to avoid the prompt.

## Value

The path to the new rule file, invisibly.

## Examples

``` r
init_rule('my-rule', tempfile())
#> Created rule "my-rule" at /tmp/Rtmp1p0v0x/file1be540ee7bf7/my-rule.md.
```
