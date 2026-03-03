# remove_skill errors if skill not installed

    Code
      remove_skill("nonexistent", tmp, force = TRUE)
    Condition
      Error in `remove_skill()`:
      ! Skill "nonexistent" is not installed at '<path>'.

