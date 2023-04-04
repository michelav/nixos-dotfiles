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
    nordzy-cursor-theme
    catppuccin-gtk
  ];

  gtk = {
    enable = true;
    theme = {
      name = "${config.colorscheme.slug}";
      package = gtkThemeFromScheme { scheme = config.colorscheme; };
    };
    cursorTheme.name = "Nordzy-cursors-white";
    iconTheme = {
      name = "Nordzy-dark";
      package = pkgs.nordzy-icon-theme;
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
  };
}
