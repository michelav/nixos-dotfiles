{ pkgs, lib, ... }: {
  home.packages = with pkgs; [ pavucontrol spotify-nss-latest playerctl ];
  programs.mpv.enable = true;
}
