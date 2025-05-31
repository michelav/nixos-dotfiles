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
          "#${colors.base00}" # black
          "#${colors.base08}" # maroon
          "#${colors.base0B}" # green
          "#${colors.base0A}" # olive
          "#${colors.base0F}" # navy
          "#${colors.base0E}" # purple
          "#${colors.base0D}" # teal
          "#${colors.base04}" # silver
        ];
        brights = [
          "#${colors.base03}" # grey
          "#${colors.base08}" # red
          "#${colors.base0B}" # lime
          "#${colors.base0A}" # yellow
          "#${colors.base0F}" # blue
          "#${colors.base0F}" # fuchsia
          "#${colors.base0C}" # aqua
          "#${colors.base06}" # white
        ];
        cursor_fg = "#${colors.base00}";
        cursor_bg = "#${colors.base05}";
        selection_fg = "#${colors.base00}";
        selection_bg = "#${colors.base05}";
      };
    };
    # WARN: Having problems with multiple files opened error. Disabled reload config meanwhile. Check isue https://github.com/wez/wezterm/issues/4396
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
        }
      '';
  };
}
