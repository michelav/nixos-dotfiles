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

}
