{ config, pkgs, ... }:

let
  inherit (config) colorscheme;
  colors = colorscheme.palette;
in {
  programs.wezterm = {
    enable = true;
    package = pkgs.wezterm;
    colorSchemes = {
      "${colorscheme.slug}" = {
        foreground = "#${colors.base05}";
        background = "#${colors.base00}";

        ansi = [
          "#${colors.base07}" # black
          "#${colors.base08}" # maroon
          "#${colors.base0B}" # green
          "#${colors.base0A}" # olive
          "#${colors.base0C}" # navy
          "#${colors.base0E}" # purple
          "#${colors.base0C}" # teal
          "#${colors.base01}" # silver
        ];
        brights = [
          "#${colors.base04}" # grey
          "#${colors.base08}" # red
          "#${colors.base0B}" # lime
          "#${colors.base0A}" # yellow
          "#${colors.base0D}" # blue
          "#${colors.base0E}" # fuchsia
          "#${colors.base0D}" # aqua
          "#${colors.base00}" # white
        ];
        cursor_fg = "#${colors.base00}";
        cursor_bg = "#${colors.base05}";
        selection_fg = "#${colors.base00}";
        selection_bg = "#${colors.base05}";
      };
    };
    extraConfig = # lua
      ''
        return {
          font = wezterm.font("${config.userPrefs.fonts.monospace.name}"),
          font_size = 12.0,
          color_scheme = "${colorscheme.slug}",
          hide_tab_bar_if_only_one_tab = true,
          window_close_confirmation = "NeverPrompt",
          set_environment_variables = {
            TERM = 'wezterm',
          },
        }
      '';
  };
}
