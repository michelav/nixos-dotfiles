---
name: nixos-change
description: Use for NixOS, Home Manager, flake, impermanence, sops-nix, Hyprland, NVIDIA, package, overlay, or host configuration changes in this repository.
paths:
  - "**/*.nix"
  - "flake.lock"
  - "hosts/**"
  - "home/**"
  - "modules/**"
  - "packages/**"
  - "overlays/**"
  - "shells/**"
---

# NixOS change workflow

Follow this workflow for NixOS/Home Manager changes.

## 1. Locate ownership

Choose the smallest owning area:

- Host-specific system behavior: `hosts/vega/`.
- Shared system behavior: `hosts/common/`.
- User-level tools and desktop config: `home/michel/`.
- Reusable NixOS modules: `modules/nixos/`.
- Reusable Home Manager modules: `modules/hm/`.
- Custom packages: `packages/`.
- Overlays: `overlays/`.
- Dev shells: `shells/` or `flake.nix`.

Do not add a new module until existing imports and nearby files have been inspected.

## 2. Edit minimally

- Preserve the existing style.
- Use two-space indentation.
- Prefer small modules with clear names.
- Avoid mixing unrelated host, home, package, and formatting changes.

## 3. Secrets and persistence

- Never reveal plaintext secrets.
- For new secrets, use the existing sops-nix pattern.
- For stateful services, check whether impermanence persistence is needed.

## 4. Validate

Run the strongest reasonable validation:

```sh
nix fmt
nix flake check
nixos-rebuild build --flake .#vega
```

Only run:

```sh
nixos-rebuild switch --flake .#vega
```

when the user explicitly asks to apply the change.

## 5. Report

End with:

- files changed;
- validation commands run;
- failures or skipped checks;
- host-specific impact.
