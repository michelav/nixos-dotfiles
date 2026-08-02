{
  inputs,
  config,
  pkgs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  stylix = config.stylix;
  whiteSurNord = pkgs.whitesur-gtk-theme.override {
    colorVariants = [ "dark" ];
    schemeVariants = [ "nord" ];
    themeVariants = [ "blue" ];
  };
  gtkTheme = {
    name = "WhiteSur-Dark-blue-nord";
    package = whiteSurNord;
  };
  inherit (inputs.diniamo-pkgs.packages.${system}) bibata-hyprcursor;
in
rec {

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
    colorScheme = "dark";
    gtk4.theme = gtkTheme;
    theme = gtkTheme;
    cursorTheme = {
      inherit (stylix.cursor) name package size;
    };
    font = {
      inherit (stylix.fonts.sansSerif) name package;
      size = 12;
    };
  };
  qt = {
    enable = true;
    # platformTheme.name = "gtk";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt6;
    };
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
