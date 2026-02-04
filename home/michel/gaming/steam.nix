{ pkgs, ... }:
let
  my-steam = pkgs.steam.override {
    extraPkgs =
      p: with p; [
        libgdiplus
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        libkrb5
        keyutils
      ];
  };
in
{
  home.packages = [
    my-steam
    pkgs.protontricks
    pkgs.mangohud
  ];
  home.persistence = {
    "/persist" = {
      directories = [
        ".local/share/Steam"
      ];
    };
  };
}
