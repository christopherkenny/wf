# add_agent errors if already installed without overwrite

    Code
      add_agent(fixture, path = dest_dir)
    Condition
      Error in `add_agent()`:
      ! Agent "my-agent" is already installed at '<path>'.
      i Use `overwrite = TRUE` to replace it.

# add_agent errors if local source does not exist

    Code
      add_agent(fs::path(tmp, "nonexistent.md"), path = fs::path(tmp, "agents"))
    Condition
      Error in `add_agent()`:
      ! Local agent source '<path>' does not exist.

