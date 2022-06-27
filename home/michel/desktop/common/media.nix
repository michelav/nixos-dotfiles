{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    pavucontrol
    spotify
    playerctl
  ];
  programs.mpv.enable = true;
}
