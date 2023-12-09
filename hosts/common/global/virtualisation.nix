{ pkgs, ... }: {
  imports = [
    ./docker.nix
    # ./podman.nix
  ];
  virtualisation.libvirtd.enable = true;

  environment.systemPackages = [ pkgs.virt-manager pkgs.libguestfs ];

}
