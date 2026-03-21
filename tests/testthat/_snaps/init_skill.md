# init_skill errors if skill directory already exists

    Code
      init_skill("my-skill", tmp)
    Condition
      Error in `init_skill()`:
      ! Skill directory '<path>' already exists.

# init_skill errors on invalid skill names

    Code
      init_skill("My-Skill", tmp)
    Condition
      Error in `check_item_name()`:
      ! `name` must be lowercase alphanumeric with hyphens.
      i It cannot start or end with a hyphen.
      x Got "My-Skill".

---

    Code
      init_skill("-bad", tmp)
    Condition
      Error in `check_item_name()`:
      ! `name` must be lowercase alphanumeric with hyphens.
      i It cannot start or end with a hyphen.
      x Got "-bad".

---

    Code
      init_skill("bad-", tmp)
    Condition
      Error in `check_item_name()`:
      ! `name` must be lowercase alphanumeric with hyphens.
      i It cannot start or end with a hyphen.
      x Got "bad-".

---

    Code
      init_skill("bad--name", tmp)
    Condition
      Error in `check_item_name()`:
      ! `name` cannot contain consecutive hyphens.
      x Got "bad--name".

---

    Code
      init_skill("", tmp)
    Condition
      Error in `check_item_name()`:
      ! `name` must be between 1 and 64 characters, not 0.

