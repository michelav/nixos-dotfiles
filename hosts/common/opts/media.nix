{ config, ... }:
let
  mediaDir = "${config.users.users.michel.home}/media";
in
{
  imports = [
    ./transmission.nix
    ./jellyfin.nix
  ];

  users.groups.media = { };

  users.users.michel = {
    extraGroups = [ "media" ];
  };

  users.users.jellyfin.extraGroups = [ "media" ];
  users.users.transmission.extraGroups = [ "media" ];

  # Make sure the directory exists + has correct permissions
  systemd.tmpfiles.rules = [
    "D ${mediaDir} 0770 michel media -"
    "D ${mediaDir}/movies 0770 michel media -"
    "D ${mediaDir}/series 0770 michel media -"
    "D ${mediaDir}/torrents 0770 michel media -"
  ];
}
