{ pkgs, config, ... }: {
  virtualisation = {
    libvirtd.enable = true;
    docker = {
      enable = true;
      enableNvidia = true;
      enableOnBoot = false;
    };
  };

  environment.systemPackages = [ pkgs.virt-manager pkgs.libguestfs ];

  hardware.opengl.driSupport32Bit = true;
  users.users.michel.extraGroups = [ "docker" "libvirtd" ];
}
