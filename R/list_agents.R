#' List installed agents
#'
#' Returns a data frame describing all agents installed in an agents directory.
#'
#' @param path The agents directory to inspect. Can be one of:
#'   - A known coding agent name such as `"claude_code"`, `"cursor"`, or
#'     `"github_copilot"` (see [agent_path()] for the full list) to use that
#'     agent's conventional project-scope path.
#'   - A character string giving the directory path directly.
#'   - `NULL` (the default), in which case the path is resolved from the
#'     `WF_AGENT` environment variable, or by prompting in interactive
#'     sessions. Set `WF_AGENT` in your `.Renviron` (e.g. with
#'     [usethis::edit_r_environ()]) to avoid the prompt.
#'
#' @return A data frame with columns:
#'   - `name`: agent name from frontmatter (or filename stem).
#'   - `description`: agent description from frontmatter.
#'   - `source`: the source URL or local path the agent was installed from.
#'   - `installed_at`: ISO 8601 timestamp of when the agent was installed.
#' @export
#'
#' @examples
#' list_agents(tempfile())
list_agents <- function(path = NULL) {
  path <- resolve_agent_path(path)
  empty <- data.frame(
    name = character(),
    description = character(),
    source = character(),
    installed_at = character(),
    stringsAsFactors = FALSE
  )

  if (!fs::dir_exists(path)) {
    return(empty)
  }

  files <- fs::dir_ls(path, glob = '*.md', type = 'file')
  if (length(files) == 0) {
    return(empty)
  }

  lock <- read_lock(path, agent_lock_file)

  rows <- lapply(files, function(f) {
    meta <- tryCatch(read_md_meta(f), error = function(e) list())
    name <- meta$name %||% fs::path_ext_remove(fs::path_file(f))
    desc <- meta$description %||% NA_character_
    entry <- lock[[name]]
    data.frame(
      name = name,
      description = as.character(desc),
      source = entry$source %||% NA_character_,
      installed_at = entry$installed_at %||% NA_character_,
      stringsAsFactors = FALSE
    )
  })

  do.call(rbind, rows)
}
