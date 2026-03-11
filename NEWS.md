# wf 0.0.1

* `add_skill()`, `check_skills()`, `find_skill()`, `init_skill()`, `list_skills()`, `remove_skill()`, and `update_skills()` are new functions for managing AI agent skills.
* `add_skill()`, `check_skills()`, `list_skills()`, `remove_skill()`, and `update_skills()` now default `path` to `NULL`. When `NULL`, the path is resolved from the `WF_AGENT` environment variable, or by an interactive prompt listing any detected agent directories. Passing a known agent name (e.g., `"github_copilot"`) as `path` is now also supported as a shorthand for that agent's conventional project-scope path.
* `skill_path()` now supports Posit AI (`"posit_ai"`, alias `"posit"`) with base directory `.positai`.
