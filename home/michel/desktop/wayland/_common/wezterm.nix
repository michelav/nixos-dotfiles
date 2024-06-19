{
  inputs,
  config,
  pkgs,
  ...
}:

let
  inherit (config) colorscheme;
  colors = colorscheme.palette;
in
{
  programs.wezterm = {
    enable = true;
    package = inputs.wezterm-main.packages.${pkgs.system}.default;
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
    # TODO: Enable wayland support after fix: https://github.com/wez/wezterm/issues/5103
    # FIXME: Having problems with multiple files opened error. Disabled reload config meanwhile. Check isue https://github.com/wez/wezterm/issues/4396
    extraConfig = # lua
      ''
        return {
          -- enable_wayland = false,
          automatically_reload_config = false,
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
