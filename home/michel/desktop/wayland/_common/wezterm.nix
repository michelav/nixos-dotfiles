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
        local wezterm = require 'wezterm'
        return {
          automatically_reload_config = false,
          font = wezterm.font("${config.userPrefs.fonts.monospace.name}"),
          font_size = 12.0,
          color_scheme = "${colorscheme.slug}",
          hide_tab_bar_if_only_one_tab = true,
          window_close_confirmation = "NeverPrompt",
          inactive_pane_hsb = { saturation = 0.7, brightness = 0.55 },
          -- Multiplexação ----------------------------------------------------------
          leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 },

          keys = {
            -- Splits
            { key = "-",  mods = "LEADER", action = wezterm.action.SplitVertical{domain="CurrentPaneDomain"} },
            { key = "\\", mods = "LEADER", action = wezterm.action.SplitHorizontal{domain="CurrentPaneDomain"} },

            -- Navegação entre panes
            { key = "h", mods = "LEADER", action = wezterm.action.ActivatePaneDirection "Left"  },
            { key = "j", mods = "LEADER", action = wezterm.action.ActivatePaneDirection "Down"  },
            { key = "k", mods = "LEADER", action = wezterm.action.ActivatePaneDirection "Up"    },
            { key = "l", mods = "LEADER", action = wezterm.action.ActivatePaneDirection "Right" },

            -- Redimensionar pane (5 cols/lin)
            { key = "H", mods = "LEADER", action = wezterm.action.AdjustPaneSize{ "Left",  5 } },
            { key = "J", mods = "LEADER", action = wezterm.action.AdjustPaneSize{ "Down",  5 } },
            { key = "K", mods = "LEADER", action = wezterm.action.AdjustPaneSize{ "Up",    5 } },
            { key = "L", mods = "LEADER", action = wezterm.action.AdjustPaneSize{ "Right", 5 } },

            -- Zoom
            { key = "z", mods = "LEADER", action = "TogglePaneZoomState" },

            -- Tabs
            { key = "c",       mods = "LEADER",       action = wezterm.action.SpawnTab "CurrentPaneDomain" },
            { key = "n",       mods = "LEADER",       action = wezterm.action.ActivateTabRelative( 1)      },
            { key = "p",       mods = "LEADER|SHIFT", action = wezterm.action.ActivateTabRelative(-1)      },
            { key = "m",       mods = "LEADER",       action = wezterm.action_callback(
                                                                        function(win, pane)
                                                                            local tab, window = pane:move_to_new_tab()
                                                                         end
                                                                        )},

            -- PaneSelect / fechar
            { key = "p", mods = "LEADER", action = wezterm.action.PaneSelect{ mode = "Activate" } },
            { key = "x", mods = "LEADER", action = wezterm.action.CloseCurrentPane{ confirm = true } },

            -- Copiar/colar Wayland friendly
            { key = "v", mods = "LEADER", action = "ActivateCopyMode" },
            { key = "y", mods = "SHIFT|CTRL", action = wezterm.action{ CopyTo = "ClipboardAndPrimarySelection" } },
            { key = "Insert", mods = "SHIFT", action = wezterm.action.PasteFrom 'Clipboard' },
          },
        }
      '';
  };
}
