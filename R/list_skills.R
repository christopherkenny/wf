#' List installed skills
#'
#' Returns a data frame describing all skills installed in a skills directory.
#'
#' @param path The skills directory to inspect. Defaults to [skill_path()],
#'   which resolves the agent from `WF_AGENT`, a directory scan, or falls
#'   back to `"claude_code"`.
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
list_skills <- function(path = skill_path()) {
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

  lock <- read_lock(path)

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
