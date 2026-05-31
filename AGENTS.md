# Repository Guidelines

## Purpose

This repository defines Michel's NixOS system and Home Manager configuration using Nix flakes.

Keep changes declarative, reproducible, and scoped. Prefer editing existing Nix modules instead of adding imperative install steps.

## Repository map

- `flake.nix`: flake inputs, outputs, host definitions, packages, formatters, and dev shells.
- `hosts/`: NixOS host configurations.
  - `hosts/vega/`: current main host.
  - `hosts/common/global/`: base system concerns such as Nix, sops, and virtualization.
  - `hosts/common/opts/`: optional system-level features such as Wayland, NVIDIA, networking, media, monitoring, and power management.
- `home/michel/`: Home Manager configuration for user `michel`.
  - `cli/`, `dev/`, `desktop/wayland/`, `cloud/`, `gaming/`, `media/`, `writing/`.
- `modules/nixos/`: reusable NixOS modules.
- `modules/hm/`: reusable Home Manager modules.
- `packages/`: custom packages exposed by the flake.
- `overlays/`: local overlays.
- `shells/`: language-specific development shells.
- `vibe/`: user-requested prompt/history notes only.

## Commands

Use these commands from the repository root:

```sh
nix develop
nix fmt
nix flake check
nixos-rebuild build --flake .#vega
```

Use `nixos-rebuild switch --flake .#vega` only when the user explicitly asks to apply the system configuration.

For package changes:

```sh
nix build .#packages.x86_64-linux.<name>
```

## Nix style

- Use two-space indentation.
- Keep modules small and domain-oriented.
- Prefer `lib.mkIf`, `lib.mkEnableOption`, and reusable options when a feature may be toggled.
- Avoid large unrelated edits.
- Do not reorder big attribute sets unless needed.

## Formatting policy

Do not run `nix fmt` over the entire repository unless explicitly requested.

When changing Nix files:
- preserve existing formatting whenever possible;
- format only files that were modified by the task;
- avoid unrelated formatting changes;
- if broad formatting is required, propose it as a separate commit;
- keep functional changes and formatting-only changes separated.

## Host and Home Manager rules

- Host-specific system changes belong under `hosts/<host>/`.
- Shared NixOS changes belong under `hosts/common/` or `modules/nixos/`.
- User-level apps, CLI tools, desktop config, and dotfiles belong under `home/michel/`.
- Reusable Home Manager abstractions belong under `modules/hm/`.

## Secrets and safety

- Do not commit plaintext secrets.
- Secrets are managed with `sops-nix`; keep encrypted material in the existing sops workflow.
- Do not print secret values in logs, explanations, examples, or tests.
- Be careful with impermanence paths. If adding stateful services or credentials, check whether persistence under `/persist` is required.

## Change discipline

Before editing:

- Identify the smallest module that owns the behavior.
- Inspect related imports before adding a new file.
- Prefer a minimal patch over broad restructuring.

After editing:

- Prefer `nix flake check`.
- For host changes, prefer `nixos-rebuild build --flake .#vega`.
- Summarize changed files and validation results.
