{ pkgs, lib, ... }: {
  home.packages = with pkgs; [
    pavucontrol
    spotify
    playerctl
    # helvum
  ];
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

  # TODO: Create a function withPresets to load easyeffects presets
  services.easyeffects.enable = true;
}
