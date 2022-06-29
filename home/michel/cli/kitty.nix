{ config, pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    font = {
      name = config.desktop.fonts.monospace.name;
      size = 12;
    };
  };
}
