# agent_path errors on unknown agent

    Code
      agent_path("unknown_agent")
    Condition
      Error in `agent_path()`:
      ! `agent` must be one of "claude_code", "openclaw", "codex", "cursor", "gemini_cli", "github_copilot", or "posit_ai".
      x Got "unknown_agent".

# agent_path errors on unknown scope

    Code
      agent_path("claude_code", "workspace")
    Condition
      Error in `agent_path()`:
      ! `scope` must be one of "project" or "global", not "workspace".

