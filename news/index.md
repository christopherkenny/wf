# Changelog

## wf 0.0.1

- [`add_skill()`](https://christopherkenny.github.io/wf/reference/add_skill.md),
  [`check_skills()`](https://christopherkenny.github.io/wf/reference/check_skills.md),
  [`find_skill()`](https://christopherkenny.github.io/wf/reference/find_skill.md),
  [`init_skill()`](https://christopherkenny.github.io/wf/reference/init_skill.md),
  [`list_skills()`](https://christopherkenny.github.io/wf/reference/list_skills.md),
  [`remove_skill()`](https://christopherkenny.github.io/wf/reference/remove_skill.md),
  and
  [`update_skills()`](https://christopherkenny.github.io/wf/reference/update_skills.md)
  are new functions for managing AI agent skills.
- [`add_skill()`](https://christopherkenny.github.io/wf/reference/add_skill.md),
  [`check_skills()`](https://christopherkenny.github.io/wf/reference/check_skills.md),
  [`list_skills()`](https://christopherkenny.github.io/wf/reference/list_skills.md),
  [`remove_skill()`](https://christopherkenny.github.io/wf/reference/remove_skill.md),
  and
  [`update_skills()`](https://christopherkenny.github.io/wf/reference/update_skills.md)
  now default `path` to `NULL`. When `NULL`, the path is resolved from
  the `WF_AGENT` environment variable, or by an interactive prompt
  listing any detected agent directories. Passing a known agent name
  (e.g., `"github_copilot"`) as `path` is now also supported as a
  shorthand for that agent’s conventional project-scope path.
- [`skill_path()`](https://christopherkenny.github.io/wf/reference/skill_path.md)
  now supports a `"copilot"` alias for `"github_copilot"`.
- [`skill_path()`](https://christopherkenny.github.io/wf/reference/skill_path.md)
  now supports Posit AI (`"posit_ai"`, alias `"posit"`) with base
  directory `.positai`.
