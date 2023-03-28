{ inputs, config, pkgs, lib, ... }:
let
  inherit (lib) types mkOption mkEnableOption mkIf;
  mkFontOption = kind: {
    name = mkOption {
      type = types.str;
      default = null;
      description = "Name for ${kind} font";
    };
    package = mkOption {
      type = types.package;
      default = null;
      description = "Package for ${kind} font";
    };
  };
  mkPrefOption = pref:
    mkOption {
      type = types.str;
      default = null;
      description = "Default ${pref}";
    };
  cfg = config.userPrefs;
in {
  options.userPrefs = {
    enable =
      mkEnableOption "Whether to enable preferences configuration in desktop.";
    fonts = {
      monospace = mkFontOption "monospace";
      regular = mkFontOption "regular";
    };

    browser = mkPrefOption "browser";
    editor = mkPrefOption "editor";
    colorSchemeName = mkPrefOption "colorSchemeName";
  };

  config = mkIf cfg.enable {
    fonts.fontconfig.enable = true;
    home.packages = [ cfg.fonts.monospace.package cfg.fonts.regular.package ];
    colorScheme = inputs.nix-colors.colorSchemes."${cfg.colorSchemeName}";
    home.sessionVariables = {
      EDITOR = cfg.editor;
      BROWSER = cfg.browser;
    };
  };
}
