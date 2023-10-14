{ pkgs, config, ... }: {
  virtualisation = {
    libvirtd.enable = true;
    docker = {
      enable = true;
      enableOnBoot = false;
      enableNvidia = true;
    };
  };

  environment.systemPackages = [ pkgs.virt-manager pkgs.libguestfs ];

}
