# add_skill errors if skill already installed without overwrite

    Code
      add_skill(fixture, dest_dir)
    Condition
      Error in `add_skill()`:
      ! Skill "my-skill" is already installed at '<path>'.
      i Use `overwrite = TRUE` to replace it.

# add_skill errors if local source does not exist

    Code
      add_skill(fs::path(tmp, "nonexistent"), fs::path(tmp, "skills"))
    Condition
      Error in `add_skill()`:
      ! Local skill source '<path>' does not exist.

# add_skill errors if source has no SKILL.md

    Code
      add_skill(empty_dir, fs::path(tmp, "skills"))
    Condition
      Error in `read_skill_meta()`:
      ! No 'SKILL.md' found in '<path>'.

