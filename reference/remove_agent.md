# Remove an installed agent

Deletes an agent file from an agents directory and removes it from the
lock file.

## Usage

``` r
remove_agent(name, path = NULL, force = FALSE)
```

## Arguments

- name:

  The name of the agent to remove (without the `.md` extension).

- path:

  The agents directory. Can be one of:

  - A known coding agent name such as `'claude_code'`, `'cursor'`, or
    `'github_copilot'` (see
    [`agent_path()`](https://christophertkenny.com/wf/reference/agent_path.md)
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

The name of the removed agent, invisibly.

## Examples

``` r
src <- tempfile(fileext = '.md')
writeLines(
  c('---', 'name: example', 'description: An example agent.', '---'),
  src
)
tmp <- tempfile()
add_agent(src, path = tmp)
#> Installed agent "example" to /tmp/Rtmp1p0v0x/file1be52d0549e6/example.md.
remove_agent('example', tmp, force = TRUE)
#> Removed agent "example" from /tmp/Rtmp1p0v0x/file1be52d0549e6.
```
