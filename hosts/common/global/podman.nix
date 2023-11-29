{ pkgs, config, ... }:
let dockerEnabled = config.virtualisation.docker.enable;
in {
  environment.systemPackages = [ pkgs.shadow pkgs.podman-compose ];
  virtualisation = {
    podman = {
      enable = true;
      enableNvidia = true;
      dockerCompat = !dockerEnabled;
      dockerSocket.enable = !dockerEnabled;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
