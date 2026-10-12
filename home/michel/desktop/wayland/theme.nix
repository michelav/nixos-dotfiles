{
  inputs,
  config,
  pkgs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  inherit (inputs.diniamo-pkgs.packages.${system}) bibata-hyprcursor;
in
{
  # GTK (adw-gtk3 + palette CSS, font, cursor) and Qt (Kvantum) follow the
  # active Stylix scheme and polarity.
  stylix.targets = {
    gtk.enable = true;
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
  };
  qt.enable = true;
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
