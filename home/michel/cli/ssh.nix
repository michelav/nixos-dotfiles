{ config, lib, pkgs, ... }:
{
  home.packages = [ pkgs.keychain ];

  programs.ssh = {
    enable = true;
    compression = true;
    extraConfig = ''
      AddKeysToAgent yes
    '';
    matchBlocks = {
     "github.com" = {
        identityFile = with config.home; "${homeDirectory}/.ssh/michelav_github";
  };
    };
  };
}
