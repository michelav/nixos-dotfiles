{ pkgs, config, libs, ... }:
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  }
}
