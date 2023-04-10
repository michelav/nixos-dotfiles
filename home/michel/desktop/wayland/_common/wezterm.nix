{ config, pkgs, ... }:

let
  inherit (config) colorscheme;
  inherit (colorscheme) colors;
in {
  programs.wezterm = {
    enable = true;
    colorSchemes = {
      "${colorscheme.slug}" = {
        foreground = "#${colors.base05}";
        background = "#${colors.base00}";

        ansi = [
          "#${colors.base00}" # black
          "#${colors.base0B}" # red
          "#${colors.base0E}" # green
          "#${colors.base0D}" # yellow
          "#${colors.base0A}" # blue
          "#${colors.base0F}" # magenta
          "#${colors.base08}" # cyan
          "#${colors.base05}" # white
        ];
        brights = [
          "#${colors.base03}" # brightblack
          "#${colors.base0B}" # brightred
          "#${colors.base07}" # brightgreen
          "#${colors.base0D}" # brightyellow
          "#${colors.base09}" # brightblue
          "#${colors.base0F}" # brightmagenta
          "#${colors.base08}" # brightcyan
          "#${colors.base06}" # brightwhite
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
