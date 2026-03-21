#' List installed agents
#'
#' Returns a data frame describing all agents installed in an agents directory.
#'
#' @param path `r roxy_path('agent', 'agent_path')`
#'
#' @return `r roxy_list_cols('agent')`
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

  lock <- read_lock(path, agent_lock_section)

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
