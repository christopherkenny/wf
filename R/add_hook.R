#' Install a hook script
#'
#' Installs a hook script from a GitHub repository or a local file into a
#' hooks directory, then registers it in the corresponding `settings.json`
#' so it runs on the specified lifecycle event.
#'
#' @param source One of:
#'   - A GitHub URL pointing to a repo, e.g. `"https://github.com/owner/repo"`.
#'   - A GitHub shorthand, e.g. `"owner/repo"`.
#'   - A local file path pointing to an executable script (`.sh`, `.R`,
#'     `.py`, etc.).
#' @param event The lifecycle event to attach the hook to. One of
#'   `"PreToolUse"`, `"PostToolUse"`, `"UserPromptSubmit"`, `"Stop"`, or
#'   `"SubagentStop"`.
#' @param hook For multi-hook repositories that store scripts under a
#'   `hooks/` subdirectory, the name of the hook to install (without the
#'   file extension), e.g. `hook = "lint-staged"`. When supplied, the script
#'   is read from `hooks/<hook>.<ext>` within the repository. Ignored when
#'   `source` already points to a specific file.
#' @param matcher An optional tool-name pattern (for `"PreToolUse"` and
#'   `"PostToolUse"` events) used to filter which tool calls trigger the
#'   hook, e.g. `"Bash|Edit"`. When `NULL` (the default), the hook applies
#'   to all tool calls for the event.
#' @param path The hooks directory to install into. Can be one of:
#'   - A known coding agent name such as `"claude_code"`, `"cursor"`, or
#'     `"github_copilot"` (see [hook_path()] for the full list) to use that
#'     agent's conventional project-scope path.
#'   - A character string giving the directory path directly.
#'   - `NULL` (the default), in which case the path is resolved from the
#'     `WF_AGENT` environment variable, or by prompting in interactive
#'     sessions.
#' @param settings Path to the `settings.json` file where the hook will be
#'   registered. When `NULL` (the default), defaults to
#'   `settings.json` in the parent directory of `path` (e.g. if `path` is
#'   `.claude/hooks`, uses `.claude/settings.json`).
#' @param overwrite If `FALSE` (the default), an error is raised if the hook
#'   script is already installed. Set to `TRUE` to replace it.
#' @param timeout Optional timeout in seconds for the hook command.
#' @param async If `TRUE`, the hook runs asynchronously. Default is `FALSE`.
#'
#' @return The path to the installed hook script, invisibly.
#' @export
#'
#' @examples
#' tmp_hook <- tempfile(fileext = '.sh')
#' writeLines(c('#!/bin/bash', 'echo hello'), tmp_hook)
#' tmp_dir <- tempfile()
#' tmp_settings <- tempfile(fileext = '.json')
#' add_hook(tmp_hook,
#'   event = 'PreToolUse', path = tmp_dir,
#'   settings = tmp_settings
#' )
add_hook <- function(
  source,
  event,
  hook = NULL,
  matcher = NULL,
  path = NULL,
  settings = NULL,
  overwrite = FALSE,
  timeout = NULL,
  async = FALSE
) {
  event <- rlang::arg_match(event, hook_events)
  path <- resolve_hook_path(path)
  type <- parse_source(source)

  if (type == 'github') {
    gh <- parse_gh_source(source)
    repo_root <- gh_download(gh$owner, gh$repo)
    hook_file <- find_hook_file(repo_root, hook, gh$path)
    sha <- gh_latest_sha(gh$owner, gh$repo)
    lock_source <- make_gh_lock_source(gh)
  } else {
    hook_file <- source
    if (!fs::file_exists(hook_file)) {
      cli::cli_abort('Local hook source {.path {hook_file}} does not exist.')
    }
    sha <- NULL
    lock_source <- fs::path_abs(hook_file)
  }

  name <- fs::path_ext_remove(fs::path_file(hook_file))
  ext <- fs::path_ext(hook_file)
  dest_name <- if (nzchar(ext)) paste0(name, '.', ext) else name
  dest <- fs::path(path, dest_name)

  if (fs::file_exists(dest)) {
    if (!overwrite) {
      cli::cli_abort(
        c(
          'Hook {.val {name}} is already installed at {.path {dest}}.',
          'i' = 'Use {.code overwrite = TRUE} to replace it.'
        )
      )
    }
    fs::file_delete(dest)
  }

  fs::dir_create(path, recurse = TRUE)
  fs::file_copy(hook_file, dest)

  settings_path <- settings %||% default_settings_for_hook_dir(path)
  register_hook(
    event = event,
    command = dest,
    matcher = matcher,
    timeout = timeout,
    async = async,
    path = settings_path
  )

  lock <- read_lock(path, hook_lock_section)
  entry <- list(
    source = lock_source,
    type = type,
    event = event,
    command = as.character(dest),
    installed_at = format(Sys.time(), '%Y-%m-%dT%H:%M:%SZ', tz = 'UTC')
  )
  if (!is.null(sha)) {
    entry$sha <- sha
  }
  lock[[name]] <- entry
  write_lock(path, lock, hook_lock_section)

  cli::cli_inform('Installed hook {.val {name}} to {.path {dest}}.')
  invisible(dest)
}

# Find the hook script file in a downloaded repo root.
# Returns an absolute path to the script file.
find_hook_file <- function(repo_root, hook, gh_path) {
  # If a specific path was already parsed from the URL, use it directly
  if (!is.null(gh_path)) {
    candidate <- fs::path(repo_root, gh_path)
    if (fs::file_exists(candidate)) {
      return(candidate)
    }
    cli::cli_abort('Path {.path {gh_path}} not found in downloaded archive.')
  }

  if (!is.null(hook)) {
    matches <- fs::dir_ls(fs::path(repo_root, 'hooks'), glob = paste0('*/', hook, '.*'))
    if (length(matches) == 0) {
      matches <- fs::dir_ls(fs::path(repo_root, 'hooks'), glob = paste0('*/', hook))
    }
    if (length(matches) > 0) {
      return(matches[[1]])
    }
    cli::cli_abort(
      'No script for hook {.val {hook}} found under {.path hooks/} in archive.'
    )
  }

  matches <- fs::dir_ls(repo_root, glob = '*/HOOK.*')
  if (length(matches) > 0) {
    return(matches[[1]])
  }

  cli::cli_abort(
    c(
      'No hook script found in the repository root.',
      'i' = 'Expected a file named {.file HOOK.<ext>} at the repo root.',
      'i' = 'For multi-hook repos, supply the {.arg hook} argument.'
    )
  )
}
