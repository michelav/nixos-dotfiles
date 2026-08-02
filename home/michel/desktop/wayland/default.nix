{ lib, pkgs, ... }:
{
  # The Wayland session: compositor, bar, notifications and session-wide
  # theming. Plain GUI applications live in ../../apps.
  imports = [
    ./gammastep.nix
    ./keyring.nix
    ./mako.nix
    ./theme.nix
    ./hyprland
    ./shell
  ];

  home.packages = with pkgs; [
    wl-clipboard
    cliphist
    xdg-utils
  ];

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
