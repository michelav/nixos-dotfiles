# Repository guidance

This repository defines Michel's NixOS system and Home Manager configuration
using flakes. The active host is `vega`; the Home Manager user is `michel`.

## Ownership

- Host-specific system configuration: `hosts/vega/`.
- Shared system configuration: `hosts/common/` or `modules/nixos/`.
- User applications and dotfiles: `home/michel/`.
- Reusable Home Manager modules: `modules/hm/`.
- Custom packages, overlays, and development shells:
  `packages/`, `overlays/`, and `shells/`.

Inspect nearby files and their imports before introducing a new module.

## Change rules

- Keep changes declarative, reproducible, minimal, and task-scoped.
- Prefer existing module boundaries over imperative installation steps.
- Do not reorder unrelated attribute sets or mix formatting-only changes
  with functional changes.
- Do not introduce abstractions for hypothetical reuse. Add reusable options
  or modules only when requested or when an existing second consumer needs them.
- Do not update flake inputs or `flake.lock` unless dependency updates are
  part of the task.

## Safety

- Never commit, print, or expose plaintext secrets.
- Follow the existing `sops-nix` workflow.
- For stateful services or credentials, check whether persistence under
  `/persist` is required.
- Never run `nixos-rebuild switch` unless explicitly requested.

## Validation

Use the strongest relevant validation:

- Modified Nix files: `nix fmt <file>...`.
- Flake or module changes: `nix flake check`.
- Host-level changes: `nixos-rebuild build --flake .#vega`.

Never run repository-wide formatting unless explicitly requested.

Report changed files, validation performed, skipped checks, failures, and
host-specific impact.changed files and validation results.
