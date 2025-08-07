{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.plex-desktop ];
  services.plex = {
    enable = true;
    openFirewall = true;
    user = "michel";
  };
}
