{ pkgs, lib, ... }: {
  imports = [ ./easyeffects.nix ];
  home.packages = with pkgs; [ pavucontrol spotify playerctl qpwgraph ];
  programs.mpv = with pkgs; {
    enable = true;
    config = {
      profile = "gpu-hq";
      ytdl-format = "bestvideo+bestaudio";
      vo = "gpu";
    };
    profiles = {
      fast = { vo = "vdpau"; };
      "protocol.dvd" = {
        profile-desc = "profile for dvd:// streams";
        alang = "en";
      };
    };
    scripts = [ mpvScripts.mpris ];
  };
}
