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
  ];

  xdg = {
    enable = true;
    mimeApps.enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  services.dropbox.enable = true;
}
