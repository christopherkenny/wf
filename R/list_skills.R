#' List installed skills
#'
#' Returns a data frame describing all skills installed in a skills directory.
#'
#' @param path `r roxy_path('skill', 'skill_path')`
#'
#' @return `r roxy_list_cols('skill')`
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
