@AGENTS.md

## Claude Code

- Prefer plan mode before broad refactors or host-level changes.
- Use path-scoped rules and skills instead of loading large explanations into this file.
- When a task involves NixOS module design, Home Manager module structure, secrets, impermanence, or host rebuild validation, use the `/nixos-change` skill.
- Do not use `nixos-rebuild switch` unless explicitly requested.
