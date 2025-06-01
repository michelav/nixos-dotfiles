{ pkgs, inputs, ... }:
{
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    package = inputs.yazi.packages.${pkgs.system}.default;
  };
}
