---
paths:
  - "**/*.nix"
  - "flake.lock"
---

# Nix/NixOS rules

- Prefer declarative NixOS/Home Manager changes over shell scripts.
- Use the existing module hierarchy before adding new structure.
- For `flake.nix`, avoid changing inputs unless the task requires it.
- For `flake.lock`, do not update lock data unless the task is specifically about dependency updates.
- For host changes, validate with `nixos-rebuild build --flake .#vega` when possible.
- For general Nix changes, validate with `nix flake check` when possible.
- Never expose decrypted sops values.
