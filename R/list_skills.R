#' List installed skills
#'
#' Returns a data frame describing all skills installed in a skills directory.
#'
#' @param path The skills directory to inspect. Can be one of:
#'   - A known agent name such as `"claude_code"`, `"cursor"`, or
#'     `"github_copilot"` (see [skill_path()] for the full list) to use that
#'     agent's conventional project-scope path.
#'   - A character string giving the directory path directly.
#'   - `NULL` (the default), in which case the path is resolved from the
#'     `WF_AGENT` environment variable, or by prompting in interactive
#'     sessions. Set `WF_AGENT` in your `.Renviron` (e.g. with
#'     [usethis::edit_r_environ()]) to avoid the prompt.
#'
#' @return A data frame with columns:
#'   - `name`: skill name from `SKILL.md` frontmatter.
#'   - `description`: skill description from `SKILL.md` frontmatter.
#'   - `source`: the source URL or local path the skill was installed from.
#'   - `installed_at`: ISO 8601 timestamp of when the skill was installed.
#' @export
#'
#' @examples
#' list_skills(tempfile())
list_skills <- function(path = NULL) {
  path <- resolve_skill_path(path)
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

  dirs <- fs::dir_ls(path, type = 'directory')
  if (length(dirs) == 0) {
    return(empty)
  }

  lock <- read_lock(path, skill_lock_section)

  rows <- lapply(dirs, function(d) {
    meta <- tryCatch(read_skill_meta(d), error = function(e) list())
    name <- meta$name %||% fs::path_file(d)
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
