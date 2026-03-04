# Create a snapshot transform that replaces known paths with '<path>'.
# Normalizes path separators before replacing for cross-platform consistency.
snap_replace <- function(...) {
  paths <- c(...)
  function(x) {
    x <- gsub("\\\\", "/", x)
    for (p in paths) {
      x <- gsub(gsub("\\\\", "/", p), "<path>", x, fixed = TRUE)
    }
    x
  }
}
