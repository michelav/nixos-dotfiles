{ config, pkgs, inputs, ... }:
let
  inherit (inputs.nix-colors.lib-contrib { inherit pkgs; }) gtkThemeFromScheme;
in rec {

  home.packages = with pkgs; [
    # Some Fonts
    font-awesome

    # GTK Stuff
    gtk-engine-murrine
    gtk_engines
    gsettings-desktop-schemas
    nordic
    numix-cursor-theme
  ];

  gtk = {
    enable = true;
    theme = {
      name = "${config.colorscheme.slug}";
      package = gtkThemeFromScheme { scheme = config.colorscheme; };
    };
    cursorTheme.name = "Numix-Cursor-Light";
    iconTheme = {
      name = "Numix-Circle-Light";
      package = pkgs.numix-icon-theme;
    };
    font = {
      inherit (config.userPrefs.fonts.regular) name package;

      size = 12;
    };
  };
  services.xsettingsd = {
    enable = true;
    settings = {
      "Net/ThemeName" = "${gtk.theme.name}";
      "Net/IconThemeName" = "${gtk.iconTheme.name}";
    };
  };
  qt = {
    enable = true;
    platformTheme = "gtk";
    style.name = "gtk2";
  };
}
