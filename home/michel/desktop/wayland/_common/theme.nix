{
  config,
  pkgs,
  inputs,
  ...
}:
let
  inherit (inputs.nix-colors.lib-contrib { inherit pkgs; }) gtkThemeFromScheme;
  inherit (inputs.diniamo-pkgs.packages.${pkgs.system}) bibata-hyprcursor;
in
rec {

  home.packages = with pkgs; [
    # Some Fonts
    font-awesome

    # GTK Stuff
    gtk-engine-murrine
    gtk_engines
    gsettings-desktop-schemas
    nordic
    numix-cursor-theme
    tela-circle-icon-theme
    vimix-cursors
  ];

  gtk = {
    enable = true;
    theme = {
      name = "${config.colorscheme.slug}";
      package = gtkThemeFromScheme { scheme = config.colorscheme; };
    };
    # cursorTheme.name = "Bibata-Modern-Classic";
    iconTheme = {
      name = "Tela-circle-dark";
      package = pkgs.tela-circle-icon-theme;
    };
    font = {
      inherit (config.userPrefs.fonts.regular) name package;

      size = 12;
    };
  };
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "gtk2";
  };
  services.xsettingsd = {
    enable = true;
    settings = {
      "Net/ThemeName" = "${gtk.theme.name}";
      "Net/IconThemeName" = "${gtk.iconTheme.name}";
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };
  # INFO: You should also define env variables in hypr config to use hyprcursors.
  # https://wiki.hyprland.org/Hypr-Ecosystem/hyprcursor/
  home.file.".local/share/icons/Bibata-modern".source =
    "${bibata-hyprcursor}/share/icons/Bibata-modern";
}
