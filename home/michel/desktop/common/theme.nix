{ config, pkgs, inputs, ... }: {

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
    (callPackage ../../../../packages/fluent-gtk-theme { })
    (callPackage ../../../../packages/fluent-icon-theme { })
  ];

  gtk = {
    enable = true;
    theme = {
      package = pkgs.gnome.gnome-themes-extra;
      name = "Adwaita-dark";
    };

    # You may come back with theme settings after icons bug is fixed
    # https://github.com/NixOS/nixpkgs/issues/207339
    /* cursorTheme.name = "Nordzy-white-cursors";
       iconTheme = {
         name = "Nordzy-dark";
         package = pkgs.nordzy-icon-theme;
       };
       theme = {
         name = "Nordic-bluish-accent";
         package = pkgs.nordic;
       };
    */
    font = {
      inherit (config.userPrefs.fonts.regular) name package;

      size = 12;
    };
  };
}
