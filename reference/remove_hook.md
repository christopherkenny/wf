# Remove an installed hook

Deletes a hook script from the hooks directory, removes its registration
from `settings.json`, and removes it from the lock file.

## Usage

``` r
remove_hook(name, path = NULL, settings = NULL, force = FALSE)
```

## Arguments

- name:

  The name of the hook to remove (the script filename stem, e.g.
  `"lint-staged"` for `lint-staged.sh`).

- path:

  The hooks directory. Can be one of:

  - A known coding agent name such as `'claude_code'`, `'cursor'`, or
    `'github_copilot'` (see
    [`hook_path()`](https://christophertkenny.com/wf/reference/hook_path.md)
    for the full list) to use that agent's conventional project-scope
    path.

  - A character string giving the directory path directly.

  - `NULL` (the default), in which case the path is resolved from the
    `WF_AGENT` environment variable, or by prompting in interactive
    sessions. Set `WF_AGENT` in your `.Renviron` (e.g. with
    `usethis::edit_r_environ()`) to avoid the prompt.

- settings:

  Path to the `settings.json` file where the hook is registered. When
  `NULL` (the default), defaults to `settings.json` in the parent
  directory of `path`.

- force:

  If `FALSE` (the default), prompts for confirmation in interactive
  sessions. Set to `TRUE` to skip the prompt.

## Value

The name of the removed hook, invisibly.

## Examples

``` r
tmp_hook <- tempfile(fileext = '.sh')
writeLines(c('#!/bin/bash', 'echo hello'), tmp_hook)
tmp_dir <- tempfile()
tmp_settings <- tempfile(fileext = '.json')
add_hook(tmp_hook,
  event = 'PreToolUse', path = tmp_dir,
  settings = tmp_settings
)
#> Registered PreToolUse hook in /tmp/RtmpXANtVc/file1a65232d32e6.json.
#> Installed hook "file1a6543147e26" to
#> /tmp/RtmpXANtVc/file1a6563c63a9b/file1a6543147e26.sh.
remove_hook(fs::path_ext_remove(basename(tmp_hook)), tmp_dir,
  settings = tmp_settings, force = TRUE
)
#> Removed hook "file1a6543147e26" from /tmp/RtmpXANtVc/file1a6563c63a9b.
```
