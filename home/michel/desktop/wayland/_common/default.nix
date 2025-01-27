{ pkgs, ... }:
{
  imports = [
    ./bnb.nix
    ./browsers.nix
    ./images.nix
    ./gammastep.nix
    ./mako.nix
    # ./swayidle.nix
    # ./swaylock.nix
    ./theme.nix
    ./zathura.nix
    ./wezterm.nix
    ./waybar.nix
    ./comm.nix
    ./keyring.nix
    ./virt-manager.nix
  ];

  home.packages = with pkgs; [
    keepassxc
    transmission_4-gtk
    wl-clipboard
    cliphist
    xdg-utils
    fractal
    drawio
    ghostty
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
