# add_rule errors if already installed without overwrite

    Code
      add_rule(fixture, path = tmp)
    Condition
      Error in `add_rule()`:
      ! Rule "my-rule" is already installed at '<path>'.
      i Use `overwrite = TRUE` to replace it.

