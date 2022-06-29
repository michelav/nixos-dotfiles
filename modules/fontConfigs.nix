{ config, pkgs, lib, ... }:
let
  mkFontOption = kind: {
    name = lib.mkOption {
      type = lib.types.str;
      default = null;
      description = "Name for ${kind} font";
    };
    package = lib.mkOption {
      type = lib.types.package;
      default = null;
      description = "Package for ${kind} font";
    };
  };
  cfg = config.desktop.fonts;
  inherit (lib) mkEnableOption mkOption mkIf;
in
{
  options.desktop.fonts = {
      enable = mkEnableOption "Whether to enable font configurations in desktop.";
      monospace = mkFontOption "monospace";
      regular = mkFontOption "regular";
  };

  config = mkIf cfg.enable {
    fonts.fontconfig.enable = true;
    home.packages = [ cfg.monospace.package cfg.regular.package ]; 
  };
}
