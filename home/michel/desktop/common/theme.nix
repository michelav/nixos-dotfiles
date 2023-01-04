{ config, pkgs, inputs, ... }: {
  colorScheme = inputs.nix-colors.colorSchemes.nord;

  desktop.fonts = {
    enable = true;
    monospace = {
      name = "JetBrainsMono Nerd Font";
      package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
    };
    regular = {
      name = "Inconsolata";
      package = pkgs.inconsolata;
    };
  };

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
    cursorTheme.name = "Nordzy-white-cursors";
    iconTheme = {
      name = "Nordzy-dark";
      package = pkgs.nordzy-icon-theme;
    };
    theme = {
      name = "Nordic-bluish-accent";
      package = pkgs.nordic;
    };
    font = {
      inherit (config.desktop.fonts.regular) name package;

      size = 12;
    };
  };
}
