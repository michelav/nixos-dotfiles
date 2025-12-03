{ pkgs, ... }:
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };
  environment.persistence."/persist/vega" = {
    hideMounts = true;
    directories = [
      {
        directory = "/var/lib/jellyfin";
        user = "jellyfin";
        group = "jellyfin";
        mode = "u=rwx,g=rwx,o=";
      }
      {
        directory = "/var/cache/jellyfin";
        user = "jellyfin";
        group = "jellyfin";
        mode = "u=rwx,g=rwx,o=";
      }
    ];
  };
}
