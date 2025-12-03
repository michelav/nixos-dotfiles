{ config, pkgs, ... }:
{
  services.transmission = {
    enable = true;
    openFirewall = true;
    package = pkgs.transmission_4;
    settings = {
      download-dir = "${config.users.users.michel.home}/media/torrents";
      incomplete-dir-enabled = false;
    };
  };
}
