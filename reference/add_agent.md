# Install an agent

Installs a custom agent from a GitHub repository or a local file into an
agents directory. Agents are single Markdown files with YAML frontmatter
specifying at minimum a `name` and `description`.

## Usage

``` r
add_agent(source, agent = NULL, path = NULL, overwrite = FALSE)
```

## Arguments

- source:

  One of:

  - A GitHub URL pointing to a repo, e.g.
    `"https://github.com/owner/repo"`.

  - A GitHub URL pointing to a subdirectory or file, e.g.
    `"https://github.com/owner/repo/tree/main/path/to/agent.md"`.

  - A GitHub shorthand, e.g. `"owner/repo"`.

  - A local file path pointing to a Markdown file.

- agent:

  For multi-agent repositories that store agents under an `agents/`
  subdirectory, the name of the agent to install (without the `.md`
  extension), e.g. `agent = "code-reviewer"`. When supplied, the agent
  is read from `agents/<agent>.md` within the repository. Ignored when
  `source` already points to a specific path via `/tree/...`.

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

- overwrite:

  If `FALSE` (the default), an error is raised if the agent is already
  installed. Set to `TRUE` to replace it.

## Value

The path to the installed agent file, invisibly.

## Examples

``` r
src <- tempfile(fileext = '.md')
writeLines(
  c('---', 'name: example', 'description: An example agent.', '---'),
  src
)
add_agent(src, path = tempfile())
#> Installed agent "example" to /tmp/Rtmp1p0v0x/file1be53fa03cd7/example.md.
```
