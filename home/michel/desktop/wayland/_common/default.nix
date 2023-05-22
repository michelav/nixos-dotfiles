{ pkgs, ... }: {
  imports = [
    ./browsers.nix
    ./gammastep.nix
    ./mako.nix
    ./media.nix
    ./swayidle.nix
    ./swaylock.nix
    ./theme.nix
    ./zathura.nix
    ./wezterm.nix
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    keepassxc
    gnucash
    transmission-gtk
    qutebrowser
    discord
    slack
    bitwarden
    bitwarden-cli
    xdg-utils
    fractal

    # TODO: Create modules for sync files with Dropbox, Google Drive and MS One
    maestral
    maestral-gui
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
