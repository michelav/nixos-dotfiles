{ pkgs, lib, config, ... }:
{
  imports = [
    ./vscode.nix
  ];

  programs = {
    java.enable = true;
  };
}
