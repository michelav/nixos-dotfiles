{ config, ... }:
let colors = config.colorscheme.palette;
in {
  programs.kitty = {
    enable = true;
    font = {
      inherit (config.userPrefs.fonts.monospace) name;
      size = 12;
    };
    keybindings = { "ctrl+a>z" = "toggle_layout stack"; };
    settings = {
      window_padding_width = 3;
      allow_remote_control = "yes";
      foreground = "#${colors.base04}";
      background = "#${colors.base00}";
      # background_opacity = "0.8";
      selection_background = "#${colors.base05}";
      selection_foreground = "#${colors.base00}";
      url_color = "#${colors.base04}";
      cursor = "#${colors.base05}";
      active_border_color = "#${colors.base03}";
      inactive_border_color = "#${colors.base01}";
      active_tab_background = "#${colors.base00}";
      active_tab_foreground = "#${colors.base05}";
      inactive_tab_background = "#${colors.base01}";
      inactive_tab_foreground = "#${colors.base04}";
      tab_bar_background = "#${colors.base01}";
      color0 = "#${colors.base07}";
      color1 = "#${colors.base08}";
      color2 = "#${colors.base0B}";
      color3 = "#${colors.base0A}";
      color4 = "#${colors.base0D}";
      color5 = "#${colors.base0E}";
      color6 = "#${colors.base0C}";
      color7 = "#${colors.base00}";
      color8 = "#${colors.base07}";
      color9 = "#${colors.base08}";
      color10 = "#${colors.base0B}";
      color11 = "#${colors.base0A}";
      color12 = "#${colors.base0D}";
      color13 = "#${colors.base0E}";
      color14 = "#${colors.base0C}";
      color15 = "#${colors.base00}";
      color16 = "#${colors.base09}";
      color17 = "#${colors.base0F}";
      color18 = "#${colors.base01}";
      color19 = "#${colors.base02}";
      color20 = "#${colors.base04}";
      color21 = "#${colors.base06}";
    };
  };
}
