# Remove an installed rule

Deletes a rule file from a rules directory and removes it from the lock
file.

## Usage

``` r
remove_rule(name, path = NULL, force = FALSE)
```

## Arguments

- name:

  The name of the rule to remove (without the `.md` extension).

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

- force:

  If `FALSE` (the default), prompts for confirmation in interactive
  sessions. Set to `TRUE` to skip the prompt.

## Value

The name of the removed rule, invisibly.

## Examples

``` r
src <- tempfile(fileext = '.md')
writeLines(
  c('---', 'name: example', 'description: An example rule.', '---'),
  src
)
tmp <- tempfile()
add_rule(src, path = tmp)
#> Installed rule "example" to /tmp/Rtmp1p0v0x/file1be5152df015/example.md.
remove_rule('example', tmp, force = TRUE)
#> Removed rule "example" from /tmp/Rtmp1p0v0x/file1be5152df015.
```
