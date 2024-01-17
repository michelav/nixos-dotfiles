{
  specialisation.gpupt.configuration = {
    system.nixos.tags = [ "gpu-passthru" ];
    gpuPassthru = {
      enable = true;
      devices = [ "10de:1f15" "10de:10f9" ];
    };
  };
}
