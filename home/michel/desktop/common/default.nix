{ pkgs, ... }: {
  imports = [ ./theme.nix ./browsers.nix ./zathura.nix ./media.nix ];

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

  xdg = {
    enable = true;
    configFile."mimeapps.list".force = true;
    mimeApps.enable = true;
    userDirs = { enable = true; };
  };
}
