{
  inputs,
  config,
  pkgs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  inherit (inputs.diniamo-pkgs.packages.${system}) bibata-hyprcursor;
  colors = config.lib.stylix.colors;
  inheritedGtkTheme = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}";
  gtkPalette = ''
    @define-color accent_color #${colors.base0D};
    @define-color accent_bg_color #${colors.base0D};
    @define-color accent_fg_color #${colors.base00};
    @define-color destructive_color #${colors.base08};
    @define-color destructive_bg_color #${colors.base08};
    @define-color destructive_fg_color #${colors.base00};
    @define-color success_color #${colors.base0B};
    @define-color success_bg_color #${colors.base0B};
    @define-color success_fg_color #${colors.base00};
    @define-color warning_color #${colors.base0A};
    @define-color warning_bg_color #${colors.base0A};
    @define-color warning_fg_color #${colors.base00};
    @define-color error_color #${colors.base08};
    @define-color error_bg_color #${colors.base08};
    @define-color error_fg_color #${colors.base00};
    @define-color window_bg_color #${colors.base00};
    @define-color window_fg_color #${colors.base05};
    @define-color view_bg_color #${colors.base00};
    @define-color view_fg_color #${colors.base05};
    @define-color headerbar_bg_color #${colors.base01};
    @define-color headerbar_fg_color #${colors.base05};
    @define-color sidebar_bg_color #${colors.base01};
    @define-color sidebar_fg_color #${colors.base05};
    @define-color card_bg_color #${colors.base01};
    @define-color card_fg_color #${colors.base05};
    @define-color dialog_bg_color #${colors.base01};
    @define-color dialog_fg_color #${colors.base05};
    @define-color popover_bg_color #${colors.base01};
    @define-color popover_fg_color #${colors.base05};
  '';
  mkGtkTheme =
    name: css3: css4:
    pkgs.runCommand "gtk-${name}" { } ''
      cp -r ${inheritedGtkTheme} $out
      chmod -R u+w $out
      cat > $out/index.theme <<'EOF'
      [X-GNOME-Metatheme]
      Name=${name}
      Type=X-GNOME-Metatheme
      Comment=${name} GTK theme
      Encoding=UTF-8
      GtkTheme=${name}
      EOF
      cat > $out/gtk-3.0/gtk.css <<'EOF'
      @import url("${inheritedGtkTheme}/gtk-3.0/gtk.css");
      ${css3}
      EOF
      cat > $out/gtk-4.0/gtk.css <<'EOF'
      @import url("${inheritedGtkTheme}/gtk-4.0/gtk.css");
      ${css4}
      EOF
    '';
  stylixGtkTheme = mkGtkTheme "Stylix" gtkPalette gtkPalette;
  noctaliaGtkTheme =
    mkGtkTheme "Noctalia" ''@import url("file://${config.xdg.configHome}/gtk-3.0/noctalia.css");''
      ''@import url("file://${config.xdg.configHome}/gtk-4.0/noctalia.css");'';
in
{
  # Session-local GTK theme directories avoid Noctalia editing GTK CSS files
  # managed by Home Manager or changing the Stylix palette in Hyprland.
  stylix.targets = {
    gtk.enable = false;
    qt.enable = true;
  };

  home.packages = with pkgs; [
    # Some Fonts
    font-awesome

    # GTK Stuff
    gsettings-desktop-schemas
    numix-cursor-theme
    tela-circle-icon-theme
    vimix-cursors
  ];

  gtk = {
    enable = true;
    colorScheme = config.userPrefs.theme.mode;
    font = {
      name = config.stylix.fonts.sansSerif.name;
      package = config.stylix.fonts.sansSerif.package;
      size = 11;
    };
    iconTheme = {
      name = config.stylix.icons.${config.userPrefs.theme.mode};
    };
    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };
    # Let GTK load the session-local child theme instead of writing a global
    # gtk-4.0/gtk.css that would shadow its stylesheet.
    gtk4.theme = null;
  };
  qt.enable = true;
  home.sessionVariables.GTK_THEME = "Stylix";
  home.file = {
    ".config/gtk-3.0/gtk.css" = {
      text = "";
      force = true;
    };
    ".config/gtk-4.0/gtk.css" = {
      text = "";
      force = true;
    };
    ".local/share/themes/Stylix".source = stylixGtkTheme;
    ".local/share/themes/Noctalia".source = noctaliaGtkTheme;
  };
  services.xsettingsd = {
    enable = true;
    settings = {
      "Net/ThemeName" = "${config.gtk.theme.name}";
      "Net/IconThemeName" = "${config.gtk.iconTheme.name}";
    };
  };

  # INFO: You should also define env variables in hypr config to use hyprcursors.
  # https://wiki.hyprland.org/Hypr-Ecosystem/hyprcursor/
  home.file.".local/share/icons/Bibata-modern".source =
    "${bibata-hyprcursor}/share/icons/Bibata-modern";
}
