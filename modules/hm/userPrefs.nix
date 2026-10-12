{
  inputs,
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
  colors = config.lib.stylix.colors;
  # Prefer the base24 variant of a scheme; base16.nix derives base10-base17
  # from base16 slots when only a base16 file exists.
  tintedSchemes = inputs.stylix.inputs.tinted-schemes;
  schemeFile =
    name:
    let
      base24 = "${tintedSchemes}/base24/${name}.yaml";
    in
    if builtins.pathExists base24 then base24 else "${tintedSchemes}/base16/${name}.yaml";
in
{
  options.userPrefs = {
    enable = mkEnableOption "Whether to enable preferences configuration in desktop.";

    browser = mkPrefOption "browser";
    editor = mkPrefOption "editor";
    terminal = mkPrefOption "terminal";
    theme = {
      mode = mkOption {
        type = types.enum [
          "dark"
          "light"
        ];
        default = "dark";
        description = "Color mode. The `light` Home Manager specialisation overrides it.";
      };
      schemes = {
        dark = mkOption {
          type = types.str;
          default = "ayu-dark";
          description = "Tinted-theming scheme name used in dark mode.";
        };
        light = mkOption {
          type = types.str;
          default = "ayu-light";
          description = "Tinted-theming scheme name used in light mode.";
        };
      };
      tokens = mkOption {
        type = types.attrsOf types.str;
        description = ''
          Semantic colors (hex, no leading `#`) for apps without a Stylix
          target. Defaults derive from the active scheme; override any token
          individually.
        '';
      };
    };
    desktopShell = mkOption {
      type = types.enum [
        "waybar"
        "quickshell"
      ];
      default = "waybar";
      description = "Desktop shell to use for Wayland sessions.";
    };
  };

  config = mkIf cfg.enable {
    stylix = {
      enable = true;
      autoEnable = false;
      polarity = cfg.theme.mode;
      base16Scheme = schemeFile cfg.theme.schemes.${cfg.theme.mode};
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
        light = "Tela-circle-light";
        package = pkgs.tela-circle-icon-theme;
      };
    };
    userPrefs.theme.tokens = lib.mapAttrs (_: lib.mkDefault) {
      background = colors.base00;
      surface = colors.base01;
      surfaceContainer = colors.base02;
      surfaceElevated = colors.base03;
      surfaceHover = colors.base04;
      foreground = colors.base05;
      foregroundMuted = colors.base04;
      outline = colors.base03;
      primary = colors.base0C;
      primaryForeground = colors.base00;
      secondary = colors.base0D;
      success = colors.base0B;
      warning = colors.base0A;
      error = colors.base08;
    };
    home.sessionVariables = {
      EDITOR = cfg.editor;
      BROWSER = cfg.browser;
      TERMINAL = cfg.terminal;
    };
  };
}
