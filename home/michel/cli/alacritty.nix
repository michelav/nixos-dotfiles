{ config, ... }: {
  programs.alacritty = let inherit (config) userPrefs colorscheme;
  in {
    enable = true;
    settings = {
      window = {
        padding.x = 3;
        padding.y = 3;
      };
      font = {
        family.style = userPrefs.fonts.monospace.name;
        size = 12;
      };
      colors = with colorscheme.palette; {
        primary = {
          background = "#${base00}";
          foreground = "#${base06}";
          # TODO: Check if a5abb6 would be a better choice
          dim_foreground = "#${base04}";
        };
        cursor = {
          text = "#${base00}";
          cursor = "#${base05}";
        };
        vi_mode_cursor = {
          text = "#${base00}";
          cursor = "#${base05}";
        };
        selection = {
          text = "CellForeground";
          background = "#${base03}";
        };
        search = {
          matches = {
            foreground = "CellBackground";
            background = "#${base08}";
          };
          footer_bar = {
            foreground = "#${base05}";
            background = "#${base02}";
          };
        };
        normal = {
          black = "#${base01}";
          red = "#${base0B}";
          green = "#${base0E}";
          yellow = "#${base0D}";
          blue = "#${base09}";
          magenta = "#${base0F}";
          cyan = "#${base08}";
          white = "#${base05}";
        };
        bright = {
          black = "#${base03}";
          red = "#${base0B}";
          green = "#${base0E}";
          yellow = "#${base0D}";
          blue = "#${base09}";
          magenta = "#${base0F}";
          cyan = "#${base07}";
          white = "#${base06}";
        };
        dim = {
          black = "#373e4d";
          red = "#94545d";
          green = "#809575";
          yellow = "#b29e75";
          blue = "#68809a";
          magenta = "#8c738c";
          cyan = "#6d96a5";
          white = "#aeb3bb";
        };
      };
    };
  };
}
