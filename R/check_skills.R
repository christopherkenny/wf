#' Check installed skills for available updates
#'
#' Compares each installed skill's recorded commit SHA against the latest
#' commit on GitHub. Local skills are reported as not updatable.
#'
#' @param path The skills directory to check. Can be one of:
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
#'   - `name`: skill name.
#'   - `installed_sha`: the SHA recorded at install time (`NA` for local).
#'   - `latest_sha`: the current HEAD SHA on GitHub (`NA` for local or on
#'     network failure).
#'   - `update_available`: `TRUE` if installed and latest SHAs differ.
#' @export
#'
#' @examples
#' check_skills(tempfile())
check_skills <- function(path = NULL) {
  path <- resolve_path(path)
  lock <- read_lock(path)

  if (length(lock) == 0) {
    return(data.frame(
      name = character(),
      installed_sha = character(),
      latest_sha = character(),
      update_available = logical(),
      stringsAsFactors = FALSE
    ))
  }

  rows <- lapply(names(lock), function(name) {
    entry <- lock[[name]]
    sha_val <- entry$sha
    installed_sha <- if (
      is.null(sha_val) || length(sha_val) == 0 || !is.character(sha_val)
    ) {
      NA_character_
    } else {
      sha_val
    }
    if (identical(entry$type, 'github') && !is.null(entry$source)) {
      gh <- parse_gh_source(entry$source)
      latest_sha <- tryCatch(
        gh_latest_sha(gh$owner, gh$repo),
        error = function(e) {
          cli::cli_warn(
            'Could not fetch latest SHA for {.val {name}}: {conditionMessage(e)}'
          )
          NA_character_
        }
      )
    } else {
      latest_sha <- NA_character_
    }
    update_available <- !is.na(installed_sha) &&
      !is.na(latest_sha) &&
      !identical(installed_sha, latest_sha)
    data.frame(
      name = name,
      installed_sha = installed_sha,
      latest_sha = latest_sha,
      update_available = update_available,
      stringsAsFactors = FALSE
    )
  })

  do.call(rbind, rows)
}
