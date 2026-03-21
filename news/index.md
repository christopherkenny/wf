# Changelog

## wf 0.1.0

- All installed components (skills, agents, hooks, and rules) are now
  tracked in a single `.wf-lock.json` file at the agent configuration
  root (e.g., `.claude/`) rather than separate per-type lock files in
  each subdirectory.
- [`add_agent()`](https://christophertkenny.com/wf/reference/add_agent.md),
  [`agent_path()`](https://christophertkenny.com/wf/reference/agent_path.md),
  [`check_agents()`](https://christophertkenny.com/wf/reference/check_agents.md),
  [`find_agent()`](https://christophertkenny.com/wf/reference/find_agent.md),
  [`init_agent()`](https://christophertkenny.com/wf/reference/init_agent.md),
  [`list_agents()`](https://christophertkenny.com/wf/reference/list_agents.md),
  [`remove_agent()`](https://christophertkenny.com/wf/reference/remove_agent.md),
  and
  [`update_agents()`](https://christophertkenny.com/wf/reference/update_agents.md)
  are new functions for managing custom subagents stored in
  `.{agent}/agents/`.
- [`add_hook()`](https://christophertkenny.com/wf/reference/add_hook.md)
  is a new function that installs a hook script file from GitHub or a
  local path into the agent’s hooks directory and registers it in
  `settings.json`.
  [`check_hooks()`](https://christophertkenny.com/wf/reference/check_hooks.md),
  [`find_hook()`](https://christophertkenny.com/wf/reference/find_hook.md),
  [`hook_path()`](https://christophertkenny.com/wf/reference/hook_path.md),
  [`init_hook()`](https://christophertkenny.com/wf/reference/init_hook.md),
  [`list_hooks()`](https://christophertkenny.com/wf/reference/list_hooks.md),
  [`remove_hook()`](https://christophertkenny.com/wf/reference/remove_hook.md),
  and
  [`update_hooks()`](https://christophertkenny.com/wf/reference/update_hooks.md)
  round out the hooks lifecycle, mirroring the skills/agents/rules
  pattern.
  [`hook_path()`](https://christophertkenny.com/wf/reference/hook_path.md)
  returns the hooks directory (e.g. `.claude/hooks`), not the settings
  file.
  [`register_hook()`](https://christophertkenny.com/wf/reference/register_hook.md)
  is a new function that handles bare command registration in
  `settings.json` without installing a script file.
  [`settings_path()`](https://christophertkenny.com/wf/reference/settings_path.md)
  is a new function that returns the path to a coding agent’s
  `settings.json`.
- [`add_rule()`](https://christophertkenny.com/wf/reference/add_rule.md),
  [`check_rules()`](https://christophertkenny.com/wf/reference/check_rules.md),
  [`find_rule()`](https://christophertkenny.com/wf/reference/find_rule.md),
  [`init_rule()`](https://christophertkenny.com/wf/reference/init_rule.md),
  [`list_rules()`](https://christophertkenny.com/wf/reference/list_rules.md),
  [`remove_rule()`](https://christophertkenny.com/wf/reference/remove_rule.md),
  [`rule_path()`](https://christophertkenny.com/wf/reference/rule_path.md),
  and
  [`update_rules()`](https://christophertkenny.com/wf/reference/update_rules.md)
  are new functions for managing coding rules stored in
  `.{agent}/rules/`.

## wf 0.0.1

CRAN release: 2026-03-19

- [`add_skill()`](https://christophertkenny.com/wf/reference/add_skill.md),
  [`check_skills()`](https://christophertkenny.com/wf/reference/check_skills.md),
  [`find_skill()`](https://christophertkenny.com/wf/reference/find_skill.md),
  [`init_skill()`](https://christophertkenny.com/wf/reference/init_skill.md),
  [`list_skills()`](https://christophertkenny.com/wf/reference/list_skills.md),
  [`remove_skill()`](https://christophertkenny.com/wf/reference/remove_skill.md),
  and
  [`update_skills()`](https://christophertkenny.com/wf/reference/update_skills.md)
  are new functions for managing AI agent skills.
- [`add_skill()`](https://christophertkenny.com/wf/reference/add_skill.md),
  [`check_skills()`](https://christophertkenny.com/wf/reference/check_skills.md),
  [`list_skills()`](https://christophertkenny.com/wf/reference/list_skills.md),
  [`remove_skill()`](https://christophertkenny.com/wf/reference/remove_skill.md),
  and
  [`update_skills()`](https://christophertkenny.com/wf/reference/update_skills.md)
  now default `path` to `NULL`. When `NULL`, the path is resolved from
  the `WF_AGENT` environment variable, or by an interactive prompt
  listing any detected agent directories. Passing a known agent name
  (e.g., `"github_copilot"`) as `path` is now also supported as a
  shorthand for that agent’s conventional project-scope path.
- [`skill_path()`](https://christophertkenny.com/wf/reference/skill_path.md)
  now supports a `"copilot"` alias for `"github_copilot"`.
- [`skill_path()`](https://christophertkenny.com/wf/reference/skill_path.md)
  now supports Posit AI (`"posit_ai"`, alias `"posit"`) with base
  directory `.positai`.
