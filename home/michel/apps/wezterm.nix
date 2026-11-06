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
        local session = (os.getenv("XDG_CURRENT_DESKTOP") or ""):lower()

        -- Noctalia copies each palette's ANSI colors, which are often tuned
        -- for dark backgrounds and drop near 2:1 in light mode. Darken (or
        -- lighten) only the colors below 4.5:1 against the background, keeping
        -- their hue. The bg-side slot (black on dark, white on light) is left
        -- alone because programs use it as a background.
        local function readable(color, bg, ratio)
          local c, b = wezterm.color.parse(color), wezterm.color.parse(bg)
          local _, _, bg_l = b:hsla()
          for _ = 1, 40 do
            if c:contrast_ratio(b) >= ratio then break end
            c = bg_l > 0.5 and c:darken(0.05) or c:lighten(0.05)
          end
          return tostring(c)
        end

        local function noctalia_scheme()
          local ok, scheme = pcall(wezterm.color.load_scheme, wezterm.config_dir .. "/colors/Noctalia.toml")
          if not ok then return nil end
          local bg = scheme.background
          local _, _, bg_l = wezterm.color.parse(bg):hsla()
          local bg_slot = bg_l > 0.5 and 8 or 1
          for i, col in ipairs(scheme.ansi) do
            if i ~= bg_slot then scheme.ansi[i] = readable(col, bg, 4.5) end
          end
          for i, col in ipairs(scheme.brights) do
            scheme.brights[i] = readable(col, bg, 4.5)
          end
          scheme.foreground = readable(scheme.foreground, bg, 4.5)
          return scheme
        end

        local noctalia = session == "umbriel" and noctalia_scheme() or nil
        return {
          automatically_reload_config = false,
          -- Noctalia writes this scheme on palette changes. Keep Stylix as the
          -- fallback for the Hyprland session.
          color_schemes = { ["Noctalia Readable"] = noctalia },
          color_scheme = noctalia and "Noctalia Readable" or "stylix",
          color_scheme_dirs = { wezterm.config_dir .. "/colors" },
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
