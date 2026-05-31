{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib)
    types
    mkOption
    mkEnableOption
    mkIf
    ;
  mkPrefOption =
    pref:
    mkOption {
      type = types.str;
      default = null;
      description = "Default ${pref}";
    };
  cfg = config.userPrefs;
in
{
  options.userPrefs = {
    enable = mkEnableOption "Whether to enable preferences configuration in desktop.";

    browser = mkPrefOption "browser";
    editor = mkPrefOption "editor";
    terminal = mkPrefOption "terminal";
    colorSchemeName = mkPrefOption "colorSchemeName";
  };

  config = mkIf cfg.enable {
    stylix = {
      enable = true;
      autoEnable = false;
      polarity = "dark";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/${cfg.colorSchemeName}.yaml";
      fonts = {
        monospace = {
          name = "JetBrainsMono Nerd Font";
          package = pkgs.nerd-fonts.jetbrains-mono;
        };
        sansSerif = {
          name = "Inter";
          package = pkgs.inter;
        };
      };
      cursor = {
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
        size = 24;
      };
      icons = {
        enable = true;
        dark = "Tela-circle-dark";
        package = pkgs.tela-circle-icon-theme;
      };
    };
    home.sessionVariables = {
      EDITOR = cfg.editor;
      BROWSER = cfg.browser;
      TERMINAL = cfg.terminal;
    };
  };
}
