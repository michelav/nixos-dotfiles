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
  ];

  xdg = {
    enable = true;
    mimeApps.enable = true;
    userDirs = { enable = true; };
  };

  services.dropbox = {
    enable = true;
    path = "/persist/home/michel/Dropbox";
  };
}
