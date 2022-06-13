{config, pkgs, lib, ... }:
{
  imports = [
    ../sway
  ];

  home.packages = with pkgs; [
    pavucontrol
  ];
}
