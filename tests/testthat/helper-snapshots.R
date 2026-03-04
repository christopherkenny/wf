# Normalize temp directory paths in snapshots to make them reproducible
# across different runs and platforms.
normalize_snap_paths <- function(x) {
  # Unix absolute paths in single quotes
  x <- gsub("'/[^']*'", "'<path>'", x)
  # Windows absolute paths in single quotes
  x <- gsub("'[A-Za-z]:[^']*'", "'<path>'", x)
  x
}
