# skill_path errors on unknown agent

    Code
      skill_path("unknown_agent")
    Condition
      Error in `skill_path()`:
      ! `agent` must be one of "claude_code", "openclaw", "codex", "cursor", "gemini_cli", or "github_copilot".
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
      ! `agent` must be one of "claude_code", "openclaw", "codex", "cursor", "gemini_cli", or "github_copilot".
      x Got "unknown_agent".

