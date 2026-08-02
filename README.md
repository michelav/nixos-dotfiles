<!-- markdownlint-configure-file
{
  "line-length": {
    "line_length": 100
  }
}
-->

# Local NixOS Configs

This repo contains the set up of my local system using [nix expressions](https://wiki.nixos.org/wiki/Overview_of_the_Nix_Language).

One may have to face many perspectives to understand what Nix is.
Nix is a novel paradigm that provides a way to programmatically declare a system.
It's also the pure functional (domain specific) language used to declare nix expressions.
These expressions describe derivations (assets, packages, applications, etc) that compose a desired
system or development environment.
Nixpkgs is a collection of packages and a concrete production example of how nix can be used to
build packages. NixOS is the linux distribution that sits on top of Nixpkgs.

At first glance, it's not simple to catch up with Nix and NixOS. It has a steep learning curve.
Anyway, the most relevant point is: forget about imperative way of doing things.
No more *apt-get install this* or *rpm -i that*. Just use nix expressions to declare what is your
need and (hopefully) it'll be there available in your system.
This repository is based in two major components of Nix ecosystem: Nix Flakes and Home Manager.

[Nix Flakes](https://wiki.nixos.org/wiki/Flakes) is a directory tree with a nix file named *flake.nix*
that follows a specific schema to describe inputs and outputs. Inputs are the dependencies of your build
and outputs are your packages, systems, development environments, etc.

## Organization

A single host, `vega` (x86_64-linux), with Home Manager wired in as a **NixOS module** rather than
standalone. Encrypted Btrfs root that is wiped on every boot, with state preserved explicitly
through `impermanence`, and secrets managed by `sops-nix`.

| Path | Role |
| --- | --- |
| `flake.nix` | Inputs, `mkNixos`, `nixosConfigurations.vega`, `packages`, `devShells` |
| `hosts/vega/` | Host entry point: imports, hostname, locale, boot, sshd, `stateVersion` |
| `hosts/vega/hardware-configuration.nix` | LUKS, Btrfs subvolumes, swapfile, hibernate offset |
| `hosts/vega/impermanence-optin.nix` | initrd `rollback-root` service and system persistence list |
| `hosts/common/global/` | Always-on system config: base packages, fonts, nix, sops, virt |
| `hosts/common/opts/` | Opt-in feature modules. A menu, not a bundle — the host picks each one |
| `hosts/common/users/michel.nix` | Account, sops-backed password, Home Manager handoff |
| `home/michel/` | Home Manager entry point, one directory per domain |
| `home/michel/apps/` | GUI applications, independent of any compositor |
| `home/michel/desktop/wayland/` | The Wayland session: Hyprland, bar, notifications, theming |
| `modules/hm/` | Reusable HM option modules, auto-imported via `outputs.homeManagerModules` |
| `packages/`, `overlays/`, `shells/` | Local derivations, overlay hook, language dev shells |

Two conventions worth knowing before adding anything:

- **Every feature `vega` enables is listed in `hosts/vega/default.nix`.** Feature modules under
  `hosts/common/opts/` are never imported as a directory, so that file is the complete answer to
  "what does this host turn on".
- **Persistence is declared next to the thing that owns it.** A module that installs a program also
  declares that program's `home.persistence` entry. Only state with no single owner lives in
  `home/michel/hm-impermanence-optin.nix`.

Theming is centralised in `modules/hm/userPrefs.nix`: setting `userPrefs.colorSchemeName` drives
Stylix, which runs with `autoEnable = false` so each module opts in individually.

## Usage

```fish
direnv allow                                # .envrc is `use flake`; brings in nixd, sops, age, nh

nix fmt <file>...                           # formatter is nixfmt
nix flake check
nixos-rebuild build --flake .#vega          # or: nh os build .
sudo nixos-rebuild switch --flake .#vega    # or: nh os switch .

sops hosts/common/secrets.yaml              # edit secrets
nix develop .#python                        # also: haskell, rust, golang
```

To check that a refactor changed nothing, compare the built system rather than the derivation
hash — `/etc/nix/registry.json` embeds `self`, so the hash shifts on every commit regardless:

```fish
nix build --no-link --print-out-paths .#nixosConfigurations.vega.config.system.build.toplevel
```

Then diff the two result trees with store hashes normalised away.

## Host notes

Three things that are not visible from the file tree:

- **The root subvolume is wiped on every boot** and restored from the `root-blank` snapshot by the
  initrd `rollback-root` service. Create `/btrfs/root/dontwipe` to skip the rollback.
- **Anything not listed in `environment.persistence` or `home.persistence` is lost on reboot.**
  A new stateful service needs a persistence entry, or its state disappears on the next boot.
- **sops decrypts with the ed25519 *host* key** under `/persist/vega/etc/ssh/`
  (`hosts/common/global/sops.nix`). That key is persisted precisely so secrets stay decryptable
  across the wipe; dropping its persistence entry would lock the system out of its own secrets.

## Acknowledgments

This structure in the repo, some expressions and tools used are heavily inspired by Misterio's [nix config](https://github.com/Misterio77/nix-config)
awesome work. If you're going into Nix path be sure to check his getting starter [repo](https://github.com/Misterio77/nix-starter-configs).
