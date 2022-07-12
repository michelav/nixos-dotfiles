{ pkgs, config, lib, ... }:
{
  imports = [
    ./theme.nix
    ./browsers.nix
    ./zathura.nix
    ./media.nix
#    ./discord.nix
  ];

  home.packages = with pkgs; [
    keepassxc
    gnucash
    transmission-gtk
    qutebrowser
  ];

  services.dropbox.enable = true;
}
