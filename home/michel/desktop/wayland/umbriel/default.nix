{
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.umbriel.homeModules.default
    inputs.noctalia.homeModules.default
  ];

  programs.umbriel = {
    enable = true;
    settings = ./config.toml;
  };

  programs.noctalia = {
    enable = true;
    settings = {
      shell.polkit_agent = true;
      wallpaper = {
        enabled = true;
        default.path = "${config.home.homeDirectory}/Pictures/wallpapers/nixos_3440x1440_v2.jpg";
      };
      theme = {
        mode = config.userPrefs.theme.mode;
        sync_color_scheme = false;
        source = "builtin";
        builtin = "Noctalia";
        templates = {
          enable_builtin_templates = true;
          builtin_ids = [ "umbriel" ];
        };
      };
      idle.behavior = {
        lock = {
          enabled = true;
          timeout = 360;
          action = "lock";
        };
        screen-off = {
          enabled = true;
          timeout = 600;
          action = "screen_off";
        };
      };
      nightlight = {
        enabled = true;
        temperature_day = 6500;
        temperature_night = 4500;
      };
      location = {
        auto_locate = false;
        latitude = -3.75;
        longitude = -38.54;
      };
    };
  };

  home.persistence."/persist".directories = [ ".local/state/noctalia" ];
}
