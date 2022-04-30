{config, pkgs, ...}:
{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    # Some Fonts
    font-awesome
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
    (callPackage ../packages/fluent-gtk-theme {})
    (callPackage ../packages/fluent-icon-theme {})
  ];

  gtk = {
    enable = true;
    cursorTheme.name = "Fluent";
    iconTheme.name = "Fluent";
    theme.name = "Fluent";
    font = {
      name = "Roboto";
      size = 10;
    };
  };
}