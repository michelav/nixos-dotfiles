{config, pkgs, inputs, ...}:
{
  colorScheme = inputs.nix-colors.colorSchemes.catppuccin;

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    # Some Fonts
    font-awesome
    inter
    roboto
    roboto-mono
    (nerdfonts.override { fonts =
      [
        "JetBrainsMono"
        "DroidSansMono"
        "FiraCode"
        "SourceCodePro"
      ];
    })

    # GTK Stuff
    gtk-engine-murrine
    gtk_engines
    gsettings-desktop-schemas
    nordic
    nordzy-icon-theme
    nordzy-cursor-theme
    catppuccin-gtk
    (callPackage ../../../../packages/fluent-gtk-theme {})
    (callPackage ../../../../packages/fluent-icon-theme {})

  ];

  gtk = {
    enable = true;
    cursorTheme.name = "Nordzy-white-cursors";
    iconTheme.name = "Nordzy-dark";
    theme.name = "Catppuccin-red-dark";
    font = {
      name = "Inter";
      size = 10;
    };
  };

  # Setting fonts
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      document-font-name = "Inter 10";
      monospace-font-name = "FiraCode Nerd Font Mono Regular 10";
    };
    "org/gnome/desktop/wm/preferences" = {
      titlebar-font = "Inter Bold 11";
    };
  };
}
