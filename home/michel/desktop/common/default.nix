{ pkgs, config, lib, ... }:
{
  imports = [
    ./theme.nix
    ./browsers.nix
    # ./dropbox.nix
    ./media.nix
#    ./discord.nix
  ];

  home.packages = with pkgs; [
    keepassxc
    gnucash
    transmission-gtk
  ];

  services.dropbox.enable = true;
}
