{ config, pkgs, ... }:
{
  environment.systemPackages = [ pkgs.docker-compose ];
  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = false;
      storageDriver = "btrfs";
    };
  };
  environment.persistence."/persist/vega" =
    let
      dockerEnabled = config.virtualisation.docker.enable;
    in
    {
      hideMounts = true;
      directories = if dockerEnabled then [ "/var/lib/docker" ] else [ ];
    };
}
