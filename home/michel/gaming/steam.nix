{ pkgs, ... }:
let
  my-steam = pkgs.steam.override {
    extraPkgs = p:
      with p; [
        libgdiplus
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        libkrb5
        keyutils
      ];
  };
in {
  home.packages = [ my-steam pkgs.protontricks ];
  home.persistence = {
    "/persist/home/michel" = {
      allowOther = true;
      directories = [{
        # A couple of games don't play well with bindfs
        directory = ".local/share/Steam";
        method = "symlink";
      }];
    };
  };
}
