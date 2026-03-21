#' List installed rules
#'
#' Returns a data frame describing all rules installed in a rules directory.
#'
#' @param path The rules directory to inspect. Can be one of:
#'   - A known coding agent name such as `"claude_code"`, `"cursor"`, or
#'     `"github_copilot"` (see [rule_path()] for the full list) to use that
#'     agent's conventional project-scope path.
#'   - A character string giving the directory path directly.
#'   - `NULL` (the default), in which case the path is resolved from the
#'     `WF_AGENT` environment variable, or by prompting in interactive
#'     sessions. Set `WF_AGENT` in your `.Renviron` (e.g. with
#'     [usethis::edit_r_environ()]) to avoid the prompt.
#'
#' @return A data frame with columns:
#'   - `name`: rule name from frontmatter, or filename stem if no frontmatter.
#'   - `description`: rule description from frontmatter, or `NA`.
#'   - `source`: the source URL or local path the rule was installed from.
#'   - `installed_at`: ISO 8601 timestamp of when the rule was installed.
#' @export
#'
#' @examples
#' list_rules(tempfile())
list_rules <- function(path = NULL) {
  path <- resolve_rule_path(path)
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

  lock <- read_lock(path, rule_lock_file)

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
