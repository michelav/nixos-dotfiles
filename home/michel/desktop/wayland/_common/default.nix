{ pkgs, ... }: {
  imports = [
    ./browsers.nix
    ./gammastep.nix
    ./mako.nix
    ./swayidle.nix
    ./swaylock.nix
    ./theme.nix
    ./zathura.nix
    ./wezterm.nix
    ./waybar.nix
    ./maestral.nix
  ];

  home.packages = with pkgs; [
    keepassxc
    transmission-gtk
    discord
    slack
    element-desktop
    # TODO: Fix after #230971 goes to nixos-unstable
    # bitwarden
    # bitwarden-cli
    xdg-utils
    fractal
  ];

  home.sessionVariables = {
    # wayland
    XDG_SESSION_TYPE = "wayland";
    LIBSEAT_BACKEND = "logind";
    MOZ_ENABLE_WAYLAND = "1";
    GDK_BACKEND = "wayland";
    WLR_NO_HARDWARE_CURSORS = "1";
    SDL_VIDEODRIVER = "wayland";
    QT_QPA_PLATFORM = "wayland";
  };

}
