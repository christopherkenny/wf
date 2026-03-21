#' Install an agent
#'
#' Installs a custom agent from a GitHub repository or a local file into an
#' agents directory. Agents are single Markdown files with YAML frontmatter
#' specifying at minimum a `name` and `description`.
#'
#' @param source One of:
#'   - A GitHub URL pointing to a repo, e.g. `"https://github.com/owner/repo"`.
#'   - A GitHub URL pointing to a subdirectory or file, e.g.
#'     `"https://github.com/owner/repo/tree/main/path/to/agent.md"`.
#'   - A GitHub shorthand, e.g. `"owner/repo"`.
#'   - A local file path pointing to a Markdown file.
#' @param agent For multi-agent repositories that store agents under an
#'   `agents/` subdirectory, the name of the agent to install (without the
#'   `.md` extension), e.g. `agent = "code-reviewer"`. When supplied, the
#'   agent is read from `agents/<agent>.md` within the repository. Ignored
#'   when `source` already points to a specific path via `/tree/...`.
#' @param path The agents directory to install into. Can be one of:
#'   - A known coding agent name such as `"claude_code"`, `"cursor"`, or
#'     `"github_copilot"` (see [agent_path()] for the full list) to use that
#'     agent's conventional project-scope path.
#'   - A character string giving the directory path directly.
#'   - `NULL` (the default), in which case the path is resolved from the
#'     `WF_AGENT` environment variable, or by prompting in interactive
#'     sessions. Set `WF_AGENT` in your `.Renviron` (e.g. with
#'     [usethis::edit_r_environ()]) to avoid the prompt.
#' @param overwrite If `FALSE` (the default), an error is raised if the agent
#'   is already installed. Set to `TRUE` to replace it.
#'
#' @return The path to the installed agent file, invisibly.
#' @export
#'
#' @examples
#' src <- tempfile(fileext = '.md')
#' writeLines(
#'   c('---', 'name: example', 'description: An example agent.', '---'),
#'   src
#' )
#' add_agent(src, path = tempfile())
add_agent <- function(source, agent = NULL, path = NULL, overwrite = FALSE) {
  path <- resolve_agent_path(path)
  type <- parse_source(source)
  if (type == 'github') {
    gh <- parse_gh_source(source)
    if (!is.null(agent) && is.null(gh$path)) {
      gh$path <- paste0('agents/', agent, '.md')
    }
    repo_root <- gh_download(gh$owner, gh$repo)
    agent_file <- if (!is.null(gh$path)) {
      candidate <- fs::path(repo_root, gh$path)
      if (!fs::file_exists(candidate)) {
        # Try appending .md if not already present
        candidate <- fs::path(repo_root, paste0(gh$path, '.md'))
      }
      if (!fs::file_exists(candidate)) {
        cli::cli_abort(
          'Path {.path {gh$path}} not found in {gh$owner}/{gh$repo}.'
        )
      }
      candidate
    } else {
      candidate <- fs::path(repo_root, 'AGENT.md')
      if (!fs::file_exists(candidate)) {
        cli::cli_abort(
          'No {.file AGENT.md} found in {gh$owner}/{gh$repo}.'
        )
      }
      candidate
    }
    sha <- gh_latest_sha(gh$owner, gh$repo)
    lock_source <- make_gh_lock_source(gh)
  } else {
    agent_file <- source
    if (!fs::file_exists(agent_file)) {
      cli::cli_abort('Local agent source {.path {agent_file}} does not exist.')
    }
    sha <- NULL
    lock_source <- fs::path_abs(agent_file)
  }

  meta <- validate_agent_file(agent_file)
  name <- meta$name
  dest <- fs::path(path, paste0(name, '.md'))

  if (fs::file_exists(dest)) {
    if (!overwrite) {
      cli::cli_abort(
        c(
          'Agent {.val {name}} is already installed at {.path {dest}}.',
          'i' = 'Use {.code overwrite = TRUE} to replace it.'
        )
      )
    }
    fs::file_delete(dest)
  }

  fs::dir_create(path, recurse = TRUE)
  fs::file_copy(agent_file, dest)

  lock <- read_lock(path, agent_lock_section)
  entry <- list(
    source = lock_source,
    type = type,
    installed_at = format(Sys.time(), '%Y-%m-%dT%H:%M:%SZ', tz = 'UTC')
  )
  if (!is.null(sha)) {
    entry$sha <- sha
  }
  lock[[name]] <- entry
  write_lock(path, lock, agent_lock_section)

  cli::cli_inform('Installed agent {.val {name}} to {.path {dest}}.')
  invisible(dest)
}
