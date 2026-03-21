# init_hook errors if file already exists

    Code
      init_hook("my-hook", tmp)
    Condition
      Error in `init_hook()`:
      ! Hook file '<path>/my-hook.sh' already exists.

# init_hook errors on invalid name

    Code
      init_hook("Bad Name", tempfile())
    Condition
      Error in `check_item_name()`:
      ! `name` must be lowercase alphanumeric with hyphens.
      i It cannot start or end with a hyphen.
      x Got "Bad Name".

