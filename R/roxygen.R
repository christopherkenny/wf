# Internal helpers for shared roxygen documentation.
# Called inline via `r roxy_*()` in roxygen comments.

roxy_path <- function(type, path_fn) {
  paste0(
    'The ', type, 's directory. Can be one of:\n',
    "  - A known coding agent name such as `'claude_code'`, `'cursor'`, or\n",
    "    `'github_copilot'` (see [", path_fn, '()] for the full list) to use\n',
    "    that agent's conventional project-scope path.\n",
    '  - A character string giving the directory path directly.\n',
    '  - `NULL` (the default), in which case the path is resolved from the\n',
    '    `WF_AGENT` environment variable, or by prompting in interactive\n',
    '    sessions. Set `WF_AGENT` in your `.Renviron` (e.g. with\n',
    '    [usethis::edit_r_environ()]) to avoid the prompt.'
  )
}

roxy_overwrite <- function(type) {
  paste0(
    'If `FALSE` (the default), an error is raised if the ', type,
    ' is already installed. Set to `TRUE` to replace it.'
  )
}

roxy_force <- function() {
  paste0(
    'If `FALSE` (the default), prompts for confirmation in interactive ',
    'sessions. Set to `TRUE` to skip the prompt.'
  )
}

roxy_list_cols <- function(type) {
  paste0(
    'A data frame with columns:\n',
    '  - `name`: ', type, ' name from frontmatter (or filename stem).\n',
    '  - `description`: ', type, ' description from frontmatter.\n',
    '  - `source`: the source URL or local path the ', type,
    ' was installed from.\n',
    '  - `installed_at`: ISO 8601 timestamp of when the ', type,
    ' was installed.'
  )
}

roxy_check_cols <- function(type) {
  paste0(
    'A data frame with columns:\n',
    '  - `name`: ', type, ' name.\n',
    '  - `installed_sha`: the SHA recorded at install time (`NA` for local).\n',
    '  - `latest_sha`: the current HEAD SHA on GitHub (`NA` for local or on\n',
    '    network failure).\n',
    '  - `update_available`: `TRUE` if installed and latest SHAs differ.'
  )
}
