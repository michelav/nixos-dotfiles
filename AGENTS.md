# Repository Guidelines

## Project Structure & Module Organization
- `flake.nix` and `flake.lock` define inputs, outputs, and formatting for the flake.
- `hosts/` contains NixOS host definitions (e.g., `hosts/vega/default.nix`).
- `modules/` holds reusable NixOS and Home Manager modules (`modules/nixos`, `modules/hm`).
- `home/` contains per-user Home Manager config, grouped by feature (e.g., `home/michel/cli/`).
- `packages/` and `overlays/` define custom packages and overlays.
- `shells/` provides language-specific dev shells.
- `vibe/` tracks vibe coding prompts, interactions and reasoning.

## Build, Test, and Development Commands
- `nix develop` enters the default dev shell with Nix tooling.
- `nix fmt` formats Nix files using the flake formatter (`nixfmt-tree`).
- `nix flake check` evaluates the flake and runs basic checks.
- `nixos-rebuild switch --flake .#vega` applies the `vega` host configuration.
- `nix build .#packages.x86_64-linux.<name>` builds a custom package from `packages/`.

## Coding Style & Naming Conventions
- Nix files use two-space indentation; keep attribute sets aligned and readable.
- Prefer small, focused modules; group by domain (`home/michel/media/`, `hosts/common/opts/`).
- Use descriptive filenames like `gpu-passthru.nix` or `power-mgmt.nix`.
- Run `nix fmt` before committing changes.

## Vibe Coding Guidelines
- Save the current prompt in `vibe/` when asked to.
- When saving interactions, include the reasoning process and any iterations. Use markdown formatting for clarity.
- Use descriptive filenames for vibe prompts, e.g., `prompt-wezterm-config-001.md`.

## Testing Guidelines
- There is no dedicated test suite; use `nix flake check` to validate changes.
- If you add tests or checks, document how to run them in this file.

## Commit & Pull Request Guidelines
- Commit messages follow Conventional Commits: `type(scope): summary`.
  Examples: `chore(deps,nix): Update flake.lock`, `feat(home): add wezterm config`.
- Use `!` to mark breaking changes when needed.
- PRs should describe what changed, why, and any host-specific impact. Include screenshots for UI changes (e.g., Wayland theming).

## Security & Configuration Tips
- Secrets live under `hosts/common/secrets.yaml` and are managed via `sops-nix`.
- Do not commit plaintext secrets; use the repo’s existing sops workflow.
