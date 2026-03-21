# wf 0.1.0

* All installed components (skills, agents, hooks, and rules) are now tracked in a single `.wf-lock.json` file at the agent configuration root (e.g., `.claude/`) rather than separate per-type lock files in each subdirectory.

* `add_agent()`, `agent_path()`, `check_agents()`, `find_agent()`, `init_agent()`, `list_agents()`, `remove_agent()`, and `update_agents()` are new functions for managing custom subagents stored in `.{agent}/agents/`.
* `add_hook()` is a new function that installs a hook script file from GitHub or a local path into the agent's hooks directory and registers it in `settings.json`. `check_hooks()`, `find_hook()`, `hook_path()`, `init_hook()`, `list_hooks()`, `remove_hook()`, and `update_hooks()` round out the hooks lifecycle, mirroring the skills/agents/rules pattern. `hook_path()` returns the hooks directory (e.g. `.claude/hooks`), not the settings file. `register_hook()` is a new function that handles bare command registration in `settings.json` without installing a script file. `settings_path()` is a new function that returns the path to a coding agent's `settings.json`.
* `add_rule()`, `check_rules()`, `find_rule()`, `init_rule()`, `list_rules()`, `remove_rule()`, `rule_path()`, and `update_rules()` are new functions for managing coding rules stored in `.{agent}/rules/`.

# wf 0.0.1

* `add_skill()`, `check_skills()`, `find_skill()`, `init_skill()`, `list_skills()`, `remove_skill()`, and `update_skills()` are new functions for managing AI agent skills.
* `add_skill()`, `check_skills()`, `list_skills()`, `remove_skill()`, and `update_skills()` now default `path` to `NULL`. When `NULL`, the path is resolved from the `WF_AGENT` environment variable, or by an interactive prompt listing any detected agent directories. Passing a known agent name (e.g., `"github_copilot"`) as `path` is now also supported as a shorthand for that agent's conventional project-scope path.
* `skill_path()` now supports a `"copilot"` alias for `"github_copilot"`.
* `skill_path()` now supports Posit AI (`"posit_ai"`, alias `"posit"`) with base directory `.positai`.
