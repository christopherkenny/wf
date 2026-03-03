# Normalize temp directory paths in snapshots to make them reproducible
# across different runs and platforms.
normalize_snap_paths <- function(x) {
  # Replace any path segment containing a temp dir pattern
  x <- gsub(
    "'[A-Za-z:/\\\\]*[Tt]emp[A-Za-z0-9:/\\\\._-]+'",
    "'<path>'",
    x
  )
  # Also handle backtick-quoted paths
  x <- gsub(
    '`[A-Za-z:/\\\\]*[Tt]emp[A-Za-z0-9:/\\\\._-]+`',
    '`<path>`',
    x
  )
  x
}
