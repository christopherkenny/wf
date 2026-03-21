# skill_path errors on unknown agent

    Code
      skill_path("unknown_agent")
    Condition
      Error in `skill_path()`:
      ! `agent` must be one of "claude_code", "openclaw", "codex", "cursor", "gemini_cli", "github_copilot", or "posit_ai".
      x Got "unknown_agent".

# skill_path errors on unknown scope

    Code
      skill_path("claude_code", "workspace")
    Condition
      Error in `skill_path()`:
      ! `scope` must be one of "project" or "global", not "workspace".

# skill_path errors when WF_AGENT is invalid

    Code
      skill_path()
    Condition
      Error in `skill_path()`:
      ! `agent` must be one of "claude_code", "openclaw", "codex", "cursor", "gemini_cli", "github_copilot", or "posit_ai".
      x Got "unknown_agent".

# resolve_skill_path aborts when path is NULL and no env var set

    Code
      wf:::resolve_skill_path(NULL)
    Condition
      Error in `resolve_path()`:
      ! Cannot determine a skills directory.
      i Set `WF_AGENT` to one of "claude_code", "openclaw", "codex", "cursor", "gemini_cli", "github_copilot", or "posit_ai".
      i Use `usethis::edit_r_environ()` to open '.Renviron'.
      i Or supply `path` directly.

