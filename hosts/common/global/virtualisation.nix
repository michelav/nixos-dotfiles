{ pkgs, config, ... }: {
  virtualisation = {
    libvirtd.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
      enableNvidia = true;
    };
  };

  environment.systemPackages =
    [ pkgs.virt-manager pkgs.libguestfs pkgs.shadow pkgs.slirp4netns ];

}
