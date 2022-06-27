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
  ];

  services.dropbox.enable = true;
}
