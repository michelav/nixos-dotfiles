{ pkgs, config, ... }: {
  virtualisation.docker = {
    enable = true;
    enableNvidia = true;
    enableOnBoot = false;
  };

  hardware.opengl.driSupport32Bit = true;
  users.users.michel.extraGroups = [ "docker" ];
}
