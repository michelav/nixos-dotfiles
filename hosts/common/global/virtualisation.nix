{ pkgs, config, ... }: {
  virtualisation = {
    libvirtd.enable = true;
    docker = {
      enable = true;
      enableOnBoot = false;
    };
  };

  environment.systemPackages = [ pkgs.virt-manager pkgs.libguestfs ];

}
