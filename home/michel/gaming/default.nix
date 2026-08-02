{ pkgs, ... }:
{
  imports = [ ./steam.nix ];
  home.packages = [ pkgs.gamescope ];
}
