{
  inputs,
  config,
  pkgs,
  ...
}:
let
  # Accents that render as text use the on_*_container roles: across the
  # community palettes they are the only ones that keep >= 4.5:1 against the
  # surface in both modes. Plain primary/secondary/tertiary are UI accents
  # and drop near 2:1 in light mode.
  neovimTemplate = pkgs.writeText "noctalia-neovim-template.lua" ''
    require("base16-colorscheme").setup({
      base00 = "{{colors.surface.default.hex}}",
      base01 = "{{colors.surface_container.default.hex}}",
      base02 = "{{colors.surface_container_high.default.hex}}",
      base03 = "{{colors.outline.default.hex}}",
      base04 = "{{colors.on_surface_variant.default.hex}}",
      base05 = "{{colors.on_surface.default.hex}}",
      base06 = "{{colors.on_surface.default.hex}}",
      base07 = "{{colors.on_background.default.hex}}",
      base08 = "{{colors.on_error_container.default.hex}}",
      base09 = "{{colors.on_tertiary_container.default.hex}}",
      base0A = "{{colors.on_secondary_container.default.hex}}",
      base0B = "{{colors.on_primary_container.default.hex}}",
      base0C = "{{colors.tertiary_fixed_dim.default.hex}}",
      base0D = "{{colors.primary_fixed_dim.default.hex}}",
      base0E = "{{colors.secondary_fixed_dim.default.hex}}",
      base0F = "{{colors.tertiary_fixed_dim.default.hex}}",
    })
  '';
  zathuraTemplate = pkgs.writeText "noctalia-zathura-template" ''
    set default-bg              "{{colors.surface.default.rgba | set_alpha: 0.8}}"
    set default-fg              "{{colors.on_surface.default.hex}}"
    set recolor-lightcolor      "rgba(0,0,0,0)"
    set recolor-darkcolor       "{{colors.on_surface.default.hex}}"
    set statusbar-bg            "{{colors.on_primary.default.hex}}"
    set statusbar-fg            "{{colors.primary.default.hex}}"
    set inputbar-bg             "{{colors.on_primary.default.hex}}"
    set inputbar-fg             "{{colors.primary.default.hex}}"
    set notification-bg         "{{colors.on_primary.default.hex}}"
    set notification-fg         "{{colors.primary.default.hex}}"
    set notification-error-bg   "{{colors.on_error.default.hex}}"
    set notification-error-fg   "{{colors.error.default.hex}}"
    set notification-warning-bg "{{colors.primary_fixed.default.hex}}"
    set notification-warning-fg "{{colors.error_container.default.hex}}"
    set index-bg                "rgba(0,0,0,0)"
    set index-fg                "{{colors.on_surface.default.hex}}"
    set index-active-bg         "{{colors.primary.default.hex}}"
    set index-active-fg         "{{colors.on_primary.default.hex}}"
    set highlight-color         "{{colors.primary_fixed.default.rgba | set_alpha: 0.5}}"
    set highlight-active-color  "{{colors.primary_fixed_dim.default.rgba | set_alpha: 0.5}}"
    set highlight-fg            "{{colors.on_primary.default.hex}}"
    set completion-bg           "{{colors.on_primary.default.hex}}"
    set completion-fg           "{{colors.primary.default.hex}}"
    set completion-group-bg     "{{colors.on_primary.default.hex}}"
    set completion-group-fg     "{{colors.primary.default.hex}}"
    set completion-highlight-fg "{{colors.on_primary.default.hex}}"
    set completion-highlight-bg "{{colors.primary.default.hex}}"
  '';
  imvTemplate = pkgs.writeText "noctalia-imv-template" ''
    [options]
    background = "{{colors.surface.default.hex}}"

    [aliases]
    <Shift+X> = exec rm "$imv_current_file"; close
  '';
  quickshellTemplate = pkgs.writeText "noctalia-quickshell-template.json" ''
    {
      "background": "{{colors.surface.default.hex}}",
      "surface": "{{colors.surface_container.default.hex}}",
      "surfaceContainer": "{{colors.surface_container_high.default.hex}}",
      "surfaceElevated": "{{colors.surface_container_highest.default.hex}}",
      "surfaceHover": "{{colors.surface_variant.default.hex}}",
      "foreground": "{{colors.on_surface.default.hex}}",
      "foregroundMuted": "{{colors.on_surface_variant.default.hex}}",
      "outline": "{{colors.outline.default.hex}}",
      "primary": "{{colors.primary.default.hex}}",
      "primaryForeground": "{{colors.on_primary.default.hex}}",
      "secondary": "{{colors.secondary.default.hex}}",
      "success": "{{colors.tertiary.default.hex}}",
      "warning": "{{colors.secondary.default.hex}}",
      "error": "{{colors.error.default.hex}}"
    }
  '';
  teamsTemplate = pkgs.writeText "noctalia-teams-template.css" ''
    :root {
      --colorNeutralBackground1: {{colors.surface.default.hex}};
      --colorNeutralBackground2: {{colors.surface_container.default.hex}};
      --colorNeutralBackground3: {{colors.surface_container_high.default.hex}};
      --colorNeutralBackground4: {{colors.surface_container_highest.default.hex}};
      --colorNeutralBackground1Hover: {{colors.surface_variant.default.hex}};
      --colorNeutralForeground1: {{colors.on_surface.default.hex}};
      --colorNeutralForeground2: {{colors.on_surface_variant.default.hex}};
      --colorNeutralForeground3: {{colors.outline.default.hex}};
      --colorNeutralStroke1: {{colors.outline.default.hex}};
      --colorBrandBackground: {{colors.primary.default.hex}};
      --colorBrandBackgroundHover: {{colors.primary_fixed_dim.default.hex}};
      --colorBrandForeground1: {{colors.primary.default.hex}};
      --colorBrandForeground2: {{colors.secondary.default.hex}};
      --colorCompoundBrandBackground: {{colors.primary.default.hex}};
      --colorCompoundBrandBackgroundHover: {{colors.primary_fixed_dim.default.hex}};
      --colorPaletteRedBackground1: {{colors.error_container.default.hex}};
      --colorPaletteRedForeground1: {{colors.error.default.hex}};
    }

    body {
      background-color: {{colors.surface.default.hex}};
      color: {{colors.on_surface.default.hex}};
    }
  '';
in
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
        mode = "dark";
        shell_mode = "follow";
        sync_color_scheme = true;
        source = "builtin";
        builtin = "Noctalia";
        templates = {
          enable_builtin_templates = true;
          enable_community_templates = true;
          builtin_ids = [
            "qt"
          ];
          # Use the shipped WezTerm template without its post-hook: that hook
          # edits wezterm.lua, which Home Manager owns as a store symlink.
          user.wezterm = {
            input_path = "${config.programs.noctalia.package}/share/noctalia/assets/templates/wezterm/wezterm.toml";
            output_path = "$XDG_CONFIG_HOME/wezterm/colors/Noctalia.toml";
          };
          user.gtk3 = {
            input_path = "${config.programs.noctalia.package}/share/noctalia/assets/templates/gtk/gtk3.css";
            output_path = "$XDG_CONFIG_HOME/gtk-3.0/noctalia.css";
          };
          user.gtk4 = {
            input_path = "${config.programs.noctalia.package}/share/noctalia/assets/templates/gtk/gtk4.css";
            output_path = "$XDG_CONFIG_HOME/gtk-4.0/noctalia.css";
          };
          user.neovim = {
            input_path = "${neovimTemplate}";
            output_path = "$XDG_CONFIG_HOME/nvim/noctalia.lua";
          };
          user.zathura = {
            input_path = "${zathuraTemplate}";
            output_path = "$XDG_CONFIG_HOME/zathura-umbriel/noctaliarc";
          };
          user.imv = {
            input_path = "${imvTemplate}";
            output_path = "$XDG_CONFIG_HOME/imv/noctalia";
          };
          user.quickshell = {
            input_path = "${quickshellTemplate}";
            output_path = "$XDG_CONFIG_HOME/quickshell/noctalia-colors.json";
          };
          user.teams = {
            input_path = "${teamsTemplate}";
            output_path = "$XDG_CONFIG_HOME/teams-for-linux/noctalia.css";
          };
          # Replaces the community qutebrowser template: its reload hook runs
          # `pgrep -f qutebrowser`, which matches the hook's own command line
          # and starts a new browser on every palette change. `[.]` matches the
          # browser's `.qutebrowser-wrapped` argument but not this hook text.
          user.qutebrowser = {
            input_path = "${./templates/qutebrowser.py}";
            output_path = "$XDG_CONFIG_HOME/qutebrowser/noctalia/colors.py";
            post_hook = "pgrep -u \"$USER\" -f '[.]qutebrowser-wrapped' >/dev/null && qutebrowser :config-source || true";
          };
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
