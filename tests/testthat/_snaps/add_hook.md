# add_hook errors if hook already installed

    Code
      add_hook(src, event = "PreToolUse", path = tmp, settings = settings_file)
    Condition
      Error in `add_hook()`:
      ! Hook "my-hook" is already installed at '<path>/my-hook.sh'.
      i Use `overwrite = TRUE` to replace it.

# add_hook errors on local source that does not exist

    Code
      add_hook("/no/such/hook.sh", event = "PreToolUse", path = tmp, settings = settings_file)
    Condition
      Error in `add_hook()`:
      ! Local hook source '/no/such/hook.sh' does not exist.

