---
name: nix-diagnose
description: Diagnose Nix and NixOS problems using evidence-first, read-only investigation. Use for flake evaluation errors, failed derivations or builds, Home Manager failures, NixOS rebuild or activation problems, broken systemd services, packages that do not run, immutable Nix store configuration, environment or PATH conflicts, binary cache issues, hardware integration, and runtime regressions after configuration changes. Also use for Portuguese requests such as diagnosticar erro do Nix, problema no NixOS, falha no rebuild, serviço não inicia, ou pacote não funciona.
---

# Diagnose Nix and NixOS

Determine the failing layer before proposing a fix. Gather the minimum evidence that can distinguish competing causes, preserve the user's current configuration, and stop when the cause is established.

## Guardrails

- Treat a diagnosis request as read-only. Explain the fix, but do not edit configuration or activate it unless the user also requests implementation.
- Read the nearest `AGENTS.md` or equivalent repository guidance before inspecting a flake.
- Never run `nixos-rebuild switch`, `home-manager switch`, `nix flake update`, garbage collection, store repair, generation deletion, or bootloader changes during diagnosis.
- Avoid `sudo` until an essential observation is permission-protected. Ask before using it.
- Do not modify `flake.lock`; add `--no-write-lock-file` to diagnostic flake commands when applicable.
- Do not expose secrets from environment variables, configuration, command lines, or logs. Redact tokens, credentials, private URLs, and personal data from the response.
- Preserve unrelated working-tree changes. Inspect `git status --short` before commands that may create outputs in a repository.
- Prefer targeted output. Do not dump complete journals, full environments, or broad traces into the conversation.

## Classify the failure

Place the symptom in the earliest failing layer:

1. **Evaluation**: syntax, undefined variables, missing attributes, module option conflicts, infinite recursion, assertions, or flake output errors.
2. **Build**: derivation compilation, fetch or hash failures, sandbox violations, unavailable substitutes, disk exhaustion, or dependency failures.
3. **Activation**: a configuration builds but activation, user services, links, files, or generation switching fails.
4. **Runtime**: the activated system boots, but an application, service, device, network path, desktop component, or binary behaves incorrectly.

Do not investigate a later layer until the earlier relevant layer is known to succeed. Separate mixed symptoms when more than one layer fails.

## Establish the baseline

Record only facts relevant to the symptom:

- Exact command or action that fails, exit status, and first meaningful error.
- Whether the problem is reproducible and when it last worked.
- Relevant recent configuration or input changes; inspect focused diffs instead of assuming causality.
- Nix and NixOS versions when version-sensitive: `nix --version`, `nixos-version`.
- Active and booted generations when activation or reboot matters:
  `readlink -f /run/current-system` and `readlink -f /run/booted-system`.
- Actual executable or configuration path when shadowing or immutability matters:
  `type -a <command>`, `readlink -f <path>`, and `ls -l <path>`.

Ask one focused question only when the missing fact materially changes which diagnostic branch to follow.

## Investigate the selected layer

### Evaluation

1. Inspect `flake.nix`, relevant imports, and the smallest module containing the failing option.
2. Discover actual flake outputs before guessing attribute paths with `nix flake show --no-write-lock-file`.
3. Evaluate the narrowest relevant output or option. Prefer a targeted `nix eval` over a full check.
4. Use `nix flake check --no-build --no-write-lock-file` when output-schema validation is relevant.
5. Add `--show-trace` only when the concise error omits the source of the failure. Read the innermost actionable frames first.
6. Distinguish an unknown option from a wrong module import, a version mismatch, or a renamed/deprecated option.

### Build

1. Build only the failing derivation or flake output with `nix build --no-link -L --no-write-lock-file <installable>`.
2. Identify the first failed derivation; do not treat downstream failures as independent causes.
3. Use `nix log <derivation>` when the terminal output is incomplete.
4. Check disk and inode availability when failures are inconsistent or mention space: `df -h` and `df -i` for the relevant filesystems.
5. Separate source-fetch, fixed-output hash, compilation, test, sandbox, substitute, signature, and daemon failures.
6. Use `nix path-info`, `nix derivation show`, or `nix why-depends` only when closure or dependency evidence is relevant.

### Activation

1. Confirm that the exact system or Home Manager activation package builds before analyzing activation.
2. Inspect the failed unit or activation log rather than rerunning a switch.
3. Use `systemctl --failed`, focused `systemctl status <unit>`, and `journalctl -b -u <unit> -n 100 --no-pager`.
4. For user units, use `systemctl --user` and `journalctl --user`; do not mix user and system service state.
5. Check ownership, symlink targets, generated-file collisions, and immutable `/nix/store` targets when a program cannot update its configuration.
6. Compare built, active, and booted generations when the observed behavior does not match the source configuration.

### Runtime

1. Reproduce the smallest failing action outside wrappers when safe.
2. For services, inspect status, recent focused logs, dependencies, sockets, and effective unit properties.
3. For command conflicts, identify every executable on `PATH` and its resolved store path.
4. For generic Linux binaries, inspect `file <binary>` and `ldd <binary>` before suggesting `nix-ld`, FHS environments, packaging, or patching.
5. For desktop, audio, network, graphics, input, or hardware problems, inspect the relevant user service, kernel log slice, and detected device; avoid a full system log dump.
6. Compare declarative configuration, generated files, and effective runtime state. Do not assume that a successful build means the intended component is active.

## Test hypotheses efficiently

- Maintain at most three live hypotheses.
- For each hypothesis, state the evidence for it and the cheapest observation that could falsify it.
- Prefer observations that discriminate between hypotheses over generic health checks.
- Change one variable at a time only when the user authorizes an experiment.
- Stop repeating successful checks unless later changes invalidate them.
- Search current official Nix, NixOS, Home Manager, or upstream documentation only when local evidence is insufficient or the behavior is version-dependent. Prefer primary sources and compare the user's pinned version with current documentation.

## Conclude with evidence

Report concisely:

1. **Failing layer and symptom**.
2. **Most likely cause**, with confidence level.
3. **Evidence** that supports the cause and evidence that ruled out plausible alternatives.
4. **Recommended fix**, clearly separated from actions already performed.
5. **Validation command** that would confirm the fix.
6. **Unknowns or blockers**, if the evidence is insufficient.

When the cause remains uncertain, say so and provide the single next diagnostic step with the highest information value.
