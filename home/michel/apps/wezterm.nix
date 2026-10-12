{
  inputs,
  config,
  pkgs,
  ...
}:

let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  stylix.targets.wezterm = {
    enable = true;
    # The font is set in extraConfig below.
    fonts.enable = false;
  };

  programs.wezterm = {
    enable = true;
    package = inputs.wezterm-main.packages.${system}.default;
    # WARN: Having problems with multiple files opened error. Disabled reload config meanwhile. Check isue https://github.com/wez/wezterm/issues/4396
    extraConfig = # lua
      ''
        local wezterm = require 'wezterm'
        return {
          automatically_reload_config = false,
          term = "wezterm",
          font = wezterm.font("${config.stylix.fonts.monospace.name}"),
          font_size = 12.0,
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
