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
- `wayland/theme.nix` configures GTK, Qt, cursors, and desktop icon packages.
- `userPrefs.colorSchemeName` in `home/michel/default.nix` selects the Stylix
  Base16 palette used across the desktop.
- `modules/hm/userPrefs.nix` defines the shared fonts: Inter for sans-serif text
  and JetBrainsMono Nerd Font for monospace text and glyphs.

