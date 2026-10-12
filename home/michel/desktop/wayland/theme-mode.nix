{
  config,
  lib,
  pkgs,
  ...
}:
# Light/dark switching at runtime. Both variants are built together: the base
# generation is dark and `specialisation.light` (see ../../default.nix) is
# light. `theme-mode` runs the prebuilt activation of the requested variant,
# so no rebuild is involved. GTK's `color-scheme` (dconf, published by the GTK
# portal) follows the activated variant, so portal-aware apps switch live.
let
  stateDir = "${config.xdg.stateHome}/theme-mode";
  isBase = config.userPrefs.theme.mode == "dark";
  theme-mode = pkgs.writeShellApplication {
    name = "theme-mode";
    runtimeInputs = with pkgs; [
      coreutils
      procps
      systemd
    ];
    text = ''
      state="${stateDir}"
      current=$(cat "$state/mode" 2>/dev/null || echo dark)
      case "''${1:-get}" in
        get)
          echo "$current"
          exit 0
          ;;
        toggle) if [ "$current" = dark ]; then mode=light; else mode=dark; fi ;;
        dark | light) mode=$1 ;;
        *)
          echo "usage: theme-mode [get|toggle|dark|light]" >&2
          exit 2
          ;;
      esac

      if [ ! -e "$state/base" ]; then
        echo "theme-mode: $state/base missing; activate Home Manager first" >&2
        exit 1
      fi
      base=$(cat "$state/base")
      if [ "$mode" = light ]; then gen="$base/specialisation/light"; else gen="$base"; fi

      # Record the mode first: the base activation re-applies the saved mode.
      echo "$mode" >"$state/mode"
      active=$(readlink -f "${config.xdg.stateHome}/home-manager/gcroots/current-home")
      if [ "$active" != "$(readlink -f "$gen")" ]; then
        "$gen/activate"
      fi

      # Apps that do not pick up the new files by themselves.
      if command -v hyprctl >/dev/null && [ -n "''${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
        hyprctl reload >/dev/null || true
      fi
      systemctl --user try-reload-or-restart mywaybar.service || true
      if command -v makoctl >/dev/null; then makoctl reload || true; fi
      if pgrep -f qutebrowser >/dev/null; then
        ${lib.getExe config.programs.qutebrowser.package} ':config-source' || true
      fi
    '';
  };
in
{
  home.packages = [ theme-mode ];

  home.persistence."/persist".directories = [ ".local/state/theme-mode" ];

  # Only the base (dark) generation records itself and restores a saved light
  # mode, so rebuilds and reboots keep the last chosen mode. The light
  # specialisation skips this, which prevents re-activation loops.
  home.activation.themeMode = lib.mkIf isBase (
    lib.hm.dag.entryAfter [ "reloadSystemd" ] ''
      if [[ ! -v DRY_RUN ]]; then
        mkdir -p "${stateDir}"
        echo "$newGenPath" >"${stateDir}/base"
        if [[ "$(cat "${stateDir}/mode" 2>/dev/null)" == light ]]; then
          "$newGenPath/specialisation/light/activate"
        fi
      fi
    ''
  );
}
