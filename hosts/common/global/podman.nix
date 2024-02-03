{ pkgs, lib, ... }: {
  specialisation.podman.configuration = let inherit (lib) mkForce;
  in {
    environment.systemPackages = [ pkgs.shadow pkgs.podman-compose ];
    system.nixos.tags = [ "rootless" ];

    virtualisation = {
      docker = {
        enable = mkForce false;
        enableNvidia = mkForce false;
      };
      podman = {
        enable = true;
        enableNvidia = true;
        dockerCompat = true;
        dockerSocket.enable = true;

        # Required for containers under podman-compose to be able to talk to each other.
        defaultNetwork.settings.dns_enabled = true;
      };
    };
  };
}
