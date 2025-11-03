{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.keychain ];

  programs.ssh = {
    enable = true;
    extraConfig = ''
      AddKeysToAgent yes
    '';
    matchBlocks = {
      "*" = {
        compression = true;
      };
      "github.com" = {
        identityFile = with config.home; "${homeDirectory}/.ssh/michelav_github";
      };
    };
  };
}
