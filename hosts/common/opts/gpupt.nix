{ pkgs, lib, ... }: {
  specialisation.bnb.configuration = let inherit (lib) mkForce;
  in {
    boot.kernelPackages = mkForce pkgs.linuxPackages_zen;
    # hardware.nvidia.prime.offload.enable = mkForce false;
    virtualisation.docker.enableNvidia = mkForce false;
    system.nixos.tags = [ "vm-bnb" ];
    gpuPassthru = {
      enable = true;
      enableAcs = true;
      devices = [ "10de:1f15" "10de:10f9" ];
    };
  };
}
