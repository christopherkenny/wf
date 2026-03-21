# init_agent errors if file already exists

    Code
      init_agent("my-agent", tmp)
    Condition
      Error in `init_agent()`:
      ! Agent file '<path>' already exists.

# check_item_name errors on bad names

    Code
      init_agent("", tempfile())
    Condition
      Error in `check_item_name()`:
      ! `name` must be between 1 and 64 characters, not 0.

---

    Code
      init_agent("Bad-Name", tempfile())
    Condition
      Error in `check_item_name()`:
      ! `name` must be lowercase alphanumeric with hyphens.
      i It cannot start or end with a hyphen.
      x Got "Bad-Name".

---

    Code
      init_agent("no--double", tempfile())
    Condition
      Error in `check_item_name()`:
      ! `name` cannot contain consecutive hyphens.
      x Got "no--double".

