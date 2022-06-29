{ config, pkgs, lib, ... }:
{
  home.packages = [ pkgs.dunst ];
  services.dunst = {
    enable = true;
    iconTheme = with config.gtk.iconTheme; { inherit name package; };
  };
}
