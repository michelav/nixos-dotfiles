{ lib, pkgs, ... }:
let
  hyprlandTarget = "wayland-session@hyprland.desktop.target";
in
{
  # Wayland sessions: compositors, bars, notifications and session-wide
  # theming. Plain GUI applications live in ../../apps.
  imports = [
    ./gammastep.nix
    ./keyring.nix
    ./mako.nix
    ./theme.nix
    ./theme-mode.nix
    ./hyprland
    ./umbriel
    ./shell
  ];

  home.packages = with pkgs; [
    wl-clipboard
    cliphist
    xdg-utils
  ];

  systemd.user.services =
    lib.genAttrs
      [
        "cliphist"
        "cliphist-images"
        "gammastep"
        "hypridle"
        "hyprpaper"
        "mako"
        "quickshell"
      ]
      (_: {
        # UWSM waits for WAYLAND_DISPLAY here; waiting for graphical-session.target
        # would create a cycle with services wanted by the Hyprland session target.
        Unit.After = lib.mkForce [ "wayland-session-waitenv.service" ];
        Unit.PartOf = [ hyprlandTarget ];
        Install.WantedBy = lib.mkForce [ hyprlandTarget ];
      });

  home.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    LIBSEAT_BACKEND = "logind";
    MOZ_ENABLE_WAYLAND = "1";
    GDK_BACKEND = "wayland";
    WLR_NO_HARDWARE_CURSORS = "1";
    SDL_VIDEODRIVER = "wayland";
    QT_QPA_PLATFORM = "wayland";
  };

  xdg = {
    enable = true;
    configFile."mimeapps.list".force = true;
    mimeApps.enable = true;
    userDirs = {
      enable = true;
      setSessionVariables = false;
    };
    portal.enable = lib.mkForce true;
  };
}
