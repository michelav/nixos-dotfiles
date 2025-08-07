{ pkgs, ... }:
{
  environment.systemPackages = [
    (pkgs.nvtopPackages.nvidia.override { intel = true; })

    pkgs.sysstat
  ];
  programs.atop = {
    enable = true;
    setuidWrapper.enable = true;
    atopgpu.enable = true;
  };
  services = {
    sysstat.enable = true;
    glances.enable = true;
  };
}
