---
name: nix-change
description: Modify, implement, refactor, or review Nix and NixOS configuration. Use for NixOS modules, Home Manager, flakes, packages, overlays, development shells, sops-nix, impermanence, services, hardware configuration, and dependency updates. For unexplained failures, diagnose the cause before editing.
---

# Change Nix and NixOS

Implement the requested change declaratively, preserve repository conventions, and validate only what the change can affect.

## Establish scope

1. Read the nearest `AGENTS.md` or equivalent guidance.
2. Inspect `flake.nix`, relevant imports, and nearby modules before editing.
3. Classify the target as NixOS, Home Manager, package, overlay, development shell, flake output, or dependency input.
4. Inspect `git status --short` and preserve unrelated changes.

Repository-specific instructions override this generic workflow.

## Implement

- Make the smallest task-scoped change.
- Follow existing module boundaries, naming, formatting, and abstractions.
- Do not create abstractions for hypothetical future reuse.
- Keep system, user, package, dependency, and formatting changes separate.
- Do not modify `flake.lock` unless dependency changes are requested.
- Never expose plaintext secrets; follow the repository's existing secret-management workflow.
- Check persistence requirements when changing stateful services on systems using impermanence.
- Prefer declarative configuration over imperative installation or mutable files.

When fixing an unexplained failure, establish the cause first. Use `nix-diagnose` before editing when it is available.

## Validate

Use the narrowest relevant validation first:

1. Format only modified Nix files using the repository formatter.
2. Evaluate the specific option or flake output when possible.
3. Build the affected package, Home Manager activation package, or NixOS configuration.
4. Run broader flake checks only when the change affects shared outputs.

Do not run repository-wide formatting, update dependencies, activate Home Manager, or run `nixos-rebuild switch` unless explicitly requested.

Do not repeat successful checks unless later edits invalidate them.

## Report

Report concisely:

- files and behavior changed;
- validation performed and its result;
- checks skipped and why;
- relevant risks, activation steps, or host-specific impact.
