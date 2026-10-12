# Desktop configuration

This directory contains Michel's Home Manager configuration for the Wayland
desktop. `wayland/default.nix` imports the Hyprland compositor, notifications,
session services, theming, and the selected desktop shell.

## Selecting a desktop shell

Set `userPrefs.desktopShell` in `home/michel/default.nix`:

```nix
userPrefs.desktopShell = "quickshell";
```

The option is declared in `modules/hm/userPrefs.nix`. It accepts these values:

- `"quickshell"` enables the QML-based Quickshell bar, panels, generated helper
  scripts, and the `quickshell.service` user unit. See the
  [Quickshell guide](wayland/shell/quickshell/README.md) for its layout and
  customization points.
- `"waybar"` enables the Waybar configuration in
  `wayland/shell/waybar.nix` and the `mywaybar.service` user unit. Its modules,
  commands, and CSS are all defined in that file.
- `"ags"` is accepted by the option but has no implementation in this
  repository yet. Selecting it disables both the Waybar and Quickshell modules,
  so no desktop bar is started.

After changing the selection, build and activate the host configuration:

```console
sudo nixos-rebuild switch --flake .#vega
```

Home Manager starts and stops the relevant user services as part of activation.
For a manual restart after activation, use the service matching the selection:

```console
systemctl --user restart quickshell.service
systemctl --user restart mywaybar.service
```

To inspect failures:

```console
journalctl --user -u quickshell.service -b
journalctl --user -u mywaybar.service -b
```

Only run the command for the shell currently selected.

## Related configuration

- `wayland/hyprland/` contains compositor settings, bindings, launcher, lock,
  idle, clipboard, wallpaper, and session integration.
- `wayland/theme.nix` configures GTK (Stylix `gtk` target, adw-gtk3), Qt
  (Stylix `qt` target, Kvantum), cursors, and desktop icon packages.
- `userPrefs.theme.schemes` in `modules/hm/userPrefs.nix` names the
  tinted-theming schemes for dark and light mode (default Catppuccin Mocha and
  Latte). Base24 files are preferred; Base16-only schemes fall back
  automatically. Apps are themed through explicit `stylix.targets.<app>`
  entries next to each app; only apps without a target read Stylix colors or
  `userPrefs.theme.tokens` directly.
- Light/dark mode switches at runtime without a rebuild: `theme-mode
  toggle|dark|light|get` (bound to `SUPER + SHIFT + t`) activates the prebuilt
  base (dark) or `specialisation.light` Home Manager generation. The chosen mode
  persists in `~/.local/state/theme-mode` across rebuilds and reboots
  (`wayland/theme-mode.nix`).
- `modules/hm/userPrefs.nix` defines the shared fonts: Inter for sans-serif text
  and JetBrainsMono Nerd Font for monospace text and glyphs.

