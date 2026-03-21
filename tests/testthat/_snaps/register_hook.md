# register_hook errors on invalid event

    Code
      register_hook("BadEvent", "echo hi", path = settings_file)
    Condition
      Error in `register_hook()`:
      ! `event` must be one of "PreToolUse", "PostToolUse", "UserPromptSubmit", "Stop", or "SubagentStop", not "BadEvent".

