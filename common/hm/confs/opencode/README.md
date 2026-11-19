# OpenCode configuration bundle

This directory is intended to live at `opencode/` in your NixOS configuration repository.

## Contents

- `opencode.jsonc`: OpenCode V2 global configuration.
- `AGENTS.md`: your original Spec-Driven Development methodology, preserved.
- `agents/`: specialist agents.
- `skills/`: on-demand domain knowledge.
- `commands/`: reusable slash commands.
- `instructions/`: global repository exploration guidance.

## Home Manager

Keep the two existing file mappings and add recursive mappings for the directories:

```nix
home.file = {
  ".config/opencode/opencode.jsonc".source = ./opencode/opencode.jsonc;
  ".config/opencode/AGENTS.md".source = ./opencode/AGENTS.md;

  ".config/opencode/agents".source = ./opencode/agents;
  ".config/opencode/skills".source = ./opencode/skills;
  ".config/opencode/commands".source = ./opencode/commands;
  ".config/opencode/instructions".source = ./opencode/instructions;
};
```

Home Manager can link each source directory into the target path. If your existing configuration already defines `home.file`, merge these entries into it rather than declaring a second attribute set. If you prefer individual file links, use `home.file` entries for each file instead.

## Before enabling

1. Back up the current OpenCode config.
2. Confirm model IDs using `/models`.
3. Run `opencode mcp list` and complete GitHub OAuth via `/mcps`.
4. GitHub MCP calls are configured to ask for approval; this avoids unattended remote changes.
4. Run `opencode` and inspect the config diagnostics.
5. Test a read-only NixOS task before permitting system-changing commands.

## Notes

- The configuration intentionally keeps FreeHire disabled until its tools are reviewed.
- GitHub MCP is enabled, but remote OAuth must be completed interactively.
- MCP tool availability and exact GitHub toolsets depend on the server's current capabilities.
- The shell policy asks by default and then allows a short list of common read-only commands. Shell pattern matching is not a security sandbox; review each approval.
- Verify provider model IDs and variants against your installed OpenCode Go catalog. If a model ID is unavailable, replace it with the exact ID shown by `/models`.
- Your existing AGENTS.md content was preserved without rewriting its SDD requirements.
