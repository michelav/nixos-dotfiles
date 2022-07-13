{ pkgs, lib, config, ... }:
{
  imports = [
    ./vscode.nix
    ./direnv.nix
  ];

  programs = {
    java.enable = true;
  };
}
