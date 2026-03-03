#' Check installed skills for available updates
#'
#' Compares each installed skill's recorded commit SHA against the latest
#' commit on GitHub. Local skills are reported as not updatable.
#'
#' @param path The skills directory to check. Defaults to [skill_path()],
#'   which resolves the agent from `WF_AGENT`, a directory scan, or falls
#'   back to `"claude_code"`.
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
check_skills <- function(path = skill_path()) {
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
    installed_sha <- if (is.null(sha_val) || length(sha_val) == 0 || !is.character(sha_val)) {
      NA_character_
    } else {
      sha_val
    }
    if (identical(entry$type, 'github') && !is.null(entry$source)) {
      gh <- tryCatch(
        parse_gh_source(entry$source),
        error = function(e) NULL
      )
      latest_sha <- if (!is.null(gh)) {
        tryCatch(
          gh_latest_sha(gh$owner, gh$repo),
          error = function(e) NA_character_
        )
      } else {
        NA_character_
      }
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
