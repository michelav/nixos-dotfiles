{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.nvtopPackages.intel
    pkgs.nvtopPackages.nvidia
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
