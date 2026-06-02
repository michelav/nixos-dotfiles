{
  inputs,
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  inherit (inputs.hyprland.packages.${system}) hyprland xdg-desktop-portal-hyprland;
  hyprw-contrib = inputs.hyprland-contrib.packages.${system};
  # currently, there is some friction between sway and gtk:
  # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
  # the suggested way to set gtk settings is with gsettings
  # for gsettings to work, we need to tell it where the schemas are
  # using the XDG_DATA_DIR environment variable
  # run at the end of sway config
  gtk-config = pkgs.writeTextFile {
    name = "gtk-config";
    destination = "/bin/gtk-config";
    executable = true;
    text =
      let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsettings-schemas/${schema.name}";
      in
      with config.gtk;
      ''
        export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
        gnome_schema=org.gnome.desktop.interface
        gsettings set "$gnome_schema" gtk-theme "${theme.name}"
        gsettings set "$gnome_schema" icon-theme "${iconTheme.name}"
        gsettings set "$gnome_schema" font-name "${font.name}"
      '';
  };
in
{
  imports = [
    inputs.hyprland.homeManagerModules.default
    ./fuzzel.nix
    ./cliphist.nix
    ./uwsm.nix
    ./wofi.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprpaper.nix
  ];
  home.packages = [
    pkgs.hyprpicker
    pkgs.hyprcursor
    hyprw-contrib.grimblast
    gtk-config
  ];

  # Add this so we have a file chooser in the portal
  xdg.portal = {
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
      pkgs.gnome-keyring
    ];
    configPackages = [ hyprland ];
    xdgOpenUsePortal = true;
  };
  wayland.windowManager.hyprland = {
    enable = true;
    # INFO: The hyprland package is also defined in the host section. Be careful to use the same package
    # TODO: Place hyprland package in a single configuration place so there won't be any conflicts
    package = null;
    portalPackage = null;
    configType = "lua";
    settings =
      let
        palette = config.lib.stylix.colors;
        inherit (config.home.sessionVariables) TERMINAL BROWSER EDITOR;
        uwsm = lib.getExe osConfig.programs.uwsm.package;
        lua = lib.generators.mkLuaInline;
        luaString = builtins.toJSON;
        mkBind = key: dispatcher: {
          _args = [
            key
            (lua dispatcher)
          ];
        };
        mkBindWith = key: dispatcher: opts: {
          _args = [
            key
            (lua dispatcher)
            opts
          ];
        };
        mkExec = key: command: mkBind key "hl.dsp.exec_cmd(${luaString command})";
        mkFocus = key: direction: mkBind key "hl.dsp.focus({ direction = ${luaString direction} })";
        mkMoveWindow =
          key: direction: mkBind key "hl.dsp.window.move({ direction = ${luaString direction} })";
        mkWorkspaceBind =
          key: workspace: mkBind key "hl.dsp.focus({ workspace = ${luaString (toString workspace)} })";
        mkWorkspace = x: mkWorkspaceBind "SUPER + ${toString x}" x;
        mkMoveToWorkspaceBind =
          key: workspace:
          mkBind key "hl.dsp.window.move({ workspace = ${luaString (toString workspace)}, follow = false })";
        mkMoveToWorkspace = x: mkMoveToWorkspaceBind "SUPER + SHIFT + ${toString x}" x;
        mkCurve = name: x1: y1: x2: y2: {
          _args = [
            name
            {
              type = "bezier";
              points = [
                [
                  x1
                  y1
                ]
                [
                  x2
                  y2
                ]
              ];
            }
          ];
        };
        mkAnimation =
          leaf: speed: bezier: style:
          {
            inherit leaf speed bezier;
            enabled = true;
          }
          // lib.optionalAttrs (style != null) { inherit style; };
      in
      {
        config = {
          general = {
            gaps_in = 5;
            gaps_out = 10;
            border_size = 1;
            col = {
              active_border = "0xff${palette.base0C}";
              inactive_border = "0xff${palette.base02}";
            };
            layout = "master";
          };
          cursor = {
            no_hardware_cursors = true;
            inactive_timeout = 5;
            enable_hyprcursor = true;
            warp_on_change_workspace = 1;
          };
          decoration = {
            active_opacity = 0.94;
            inactive_opacity = 0.84;
            fullscreen_opacity = 1.0;
            rounding = 5;
            shadow = {
              enabled = true;
              range = 12;
              offset = "3 3";
              color = "0x44000000";
              color_inactive = "0x66000000";
            };
            blur = {
              enabled = true;
              size = 5;
              passes = 3;
              ignore_opacity = true;
            };
          };
          animations = {
            enabled = false;
          };
          dwindle = {
            preserve_split = true;
          };
          master = {
            mfact = 0.6;
            orientation = "left";
          };
          misc = {
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
          };
          input = {
            kb_layout = "us,br";
            kb_variant = "intl,";
            kb_options = " grp:alt_altgr_toggle";
            touchpad = {
              disable_while_typing = false;
            };
          };
        };
        curve = [
          (mkCurve "easein" 0.11 0 0.5 0)
          (mkCurve "easeout" 0.5 1 0.89 1)
          (mkCurve "easeinout" 0.45 0 0.55 1)
        ];
        animation = [
          (mkAnimation "windowsIn" 3 "easeout" "slide")
          (mkAnimation "windowsOut" 3 "easein" "slide")
          (mkAnimation "windowsMove" 3 "easeout" null)
          (mkAnimation "fadeIn" 3 "easeout" null)
          (mkAnimation "fadeOut" 3 "easein" null)
          (mkAnimation "fadeSwitch" 3 "easeout" null)
          (mkAnimation "fadeShadow" 3 "easeout" null)
          (mkAnimation "fadeDim" 3 "easeout" null)
          (mkAnimation "border" 3 "easeout" null)
          (mkAnimation "workspaces" 2 "easeout" "slide")
        ];
        # Bindings
        bind =
          let
            cliphist = "${pkgs.cliphist}/bin/cliphist";
            wofi = "${pkgs.wofi}/bin/wofi";
            wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy";
            makoctl = "${pkgs.mako}/bin/makoctl";
            grimblast = "${hyprw-contrib.grimblast}/bin/grimblast";
            bright = "${pkgs.brightnessctl}/bin/brightnessctl";
            bright-up = "${bright} s 5%+";
            bright-down = "${bright} s 5%-";
            wpctl = "${pkgs.wireplumber}/bin/wpctl";
            fuzzel = "${config.programs.fuzzel.package}/bin/fuzzel";
          in
          [
            {
              _args = [
                "SUPER + mouse:272"
                (lua "hl.dsp.window.drag()")
                { mouse = true; }
              ];
            }
            {
              _args = [
                "SUPER + mouse:273"
                (lua "hl.dsp.window.resize()")
                { mouse = true; }
              ];
            }
            # Basic bindings
            (mkExec "SUPER + Return" "${uwsm} app ${TERMINAL}")
            (mkExec "SUPER + b" "${uwsm} app ${BROWSER}")
            (mkExec "SUPER + v" "${cliphist} list | ${wofi} --dmenu | ${cliphist} decode | ${wl-copy}")
            (mkExec "SUPER + w" "${makoctl} dismiss")
            (mkExec "SUPER + backspace" "loginctl lock-session")
            (mkExec "Print" "${grimblast} --notify copy output")
            (mkExec "SHIFT + Print" "${grimblast} --notify copy active")
            (mkExec "CONTROL + Print" "${grimblast} --notify copy screen")
            (mkExec "SUPER + Print" "${grimblast} --notify copy window")
            (mkExec "ALT + Print" "${grimblast} --notify copy area")
            # Desktop Launchers
            (mkExec "SUPER + d" "${wofi} -f -S run")
            (mkExec "SUPER + x" "${fuzzel} --launch-prefix='uwsm app --'")
            (mkExec "Scroll_Lock" "pass-wofi")
            (mkExec "XF86Calculator" "pass-wofi")
            # Laptop brightness
            (mkBindWith "XF86MonBrightnessUp" "hl.dsp.exec_cmd(${luaString bright-up})" {
              locked = true;
              repeating = true;
            })
            (mkBindWith "XF86MonBrightnessDown" "hl.dsp.exec_cmd(${luaString bright-down})" {
              locked = true;
              repeating = true;
            })
            # Audio controls
            (mkBindWith "XF86AudioRaiseVolume"
              "hl.dsp.exec_cmd(${luaString "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%+"})"
              {
                locked = true;
                repeating = true;
              }
            )
            (mkBindWith "XF86AudioLowerVolume"
              "hl.dsp.exec_cmd(${luaString "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%-"})"
              {
                locked = true;
                repeating = true;
              }
            )
            (mkBindWith "XF86AudioMute"
              "hl.dsp.exec_cmd(${luaString "${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle"})"
              {
                locked = true;
              }
            )
            (mkBindWith "XF86AudioMicMute"
              "hl.dsp.exec_cmd(${luaString "${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle"})"
              {
                locked = true;
              }
            )
          ]
          ++ [
            # Window controls
            (mkBind "SUPER + SHIFT + q" "hl.dsp.window.close()")
            (mkExec "SUPER + SHIFT + e" "${uwsm} stop")
            (mkBind "SUPER + s" ''hl.dsp.layout("togglesplit")'')
            (mkBind "SUPER + f" ''hl.dsp.window.fullscreen({ mode = "maximized" })'')
            (mkBind "SUPER + SHIFT + f" ''hl.dsp.window.fullscreen({ mode = "fullscreen" })'')
            (mkBind "SUPER + SHIFT + space" ''hl.dsp.window.float({ action = "toggle" })'')
            (mkBind "SUPER + minus" ''hl.dsp.layout("splitratio -0.25")'')
            (mkBind "SUPER + SHIFT + minus" ''hl.dsp.layout("splitratio -0.3333333")'')
            (mkBind "SUPER + equal" ''hl.dsp.layout("splitratio 0.25")'')
            (mkBind "SUPER + SHIFT + equal" ''hl.dsp.layout("splitratio 0.3333333")'')
            (mkBind "SUPER + g" "hl.dsp.group.toggle()")
            (mkBind "SUPER + apostrophe" "hl.dsp.group.next()")
            (mkBind "SUPER + SHIFT + apostrophe" "hl.dsp.group.prev()")
            (mkFocus "SUPER + left" "left")
            (mkFocus "SUPER + right" "right")
            (mkFocus "SUPER + up" "up")
            (mkFocus "SUPER + down" "down")
            (mkFocus "SUPER + h" "left")
            (mkFocus "SUPER + l" "right")
            (mkFocus "SUPER + k" "up")
            (mkFocus "SUPER + j" "down")
            (mkMoveWindow "SUPER + SHIFT + left" "left")
            (mkMoveWindow "SUPER + SHIFT + right" "right")
            (mkMoveWindow "SUPER + SHIFT + up" "up")
            (mkMoveWindow "SUPER + SHIFT + down" "down")
            (mkMoveWindow "SUPER + SHIFT + h" "left")
            (mkMoveWindow "SUPER + SHIFT + l" "right")
            (mkMoveWindow "SUPER + SHIFT + k" "up")
            (mkMoveWindow "SUPER + SHIFT + j" "down")
            (mkBind "SUPER + CONTROL + 1" ''hl.dsp.focus({ monitor = "DP-1" })'')
            (mkBind "SUPER + CONTROL + 2" ''hl.dsp.focus({ monitor = "eDP-1" })'')
            (mkBind "SUPER + CONTROL + SHIFT + left" ''hl.dsp.window.move({ monitor = "l" })'')
            (mkBind "SUPER + CONTROL + SHIFT + right" ''hl.dsp.window.move({ monitor = "r" })'')
            (mkBind "SUPER + CONTROL + SHIFT + up" ''hl.dsp.window.move({ monitor = "u" })'')
            (mkBind "SUPER + CONTROL + SHIFT + down" ''hl.dsp.window.move({ monitor = "d" })'')
            (mkBind "SUPER + SHIFT + r" ''hl.dsp.submap("resize")'')
            (mkBind "SUPER + P" ''hl.dsp.submap("passthrough")'')
          ]
          ++
            # Workspace bindings
            (map mkWorkspace (lib.genList (x: x + 1) 9))
          ++ [
            # Special workspace bindings
            (mkBind "SUPER + u" ''hl.dsp.workspace.toggle_special("")'')
            (mkBind "SUPER + SHIFT + u" ''hl.dsp.window.move({ workspace = "special" })'')
            (mkWorkspaceBind "SUPER + 0" 10)
          ]
          ++
            # Moving WIndows to Workspace bindings
            (map mkMoveToWorkspace (lib.genList (x: x + 1) 9))
          ++ [ (mkMoveToWorkspaceBind "SUPER + SHIFT + 0" 10) ]
          ++ (
            let
              playerctl = lib.getExe' config.services.playerctld.package "playerctl";
              playerctld = lib.getExe' config.services.playerctld.package "playerctld";
            in
            lib.optionals config.services.playerctld.enable [
              # media controls
              (mkBindWith "XF86AudioNext" "hl.dsp.exec_cmd(${luaString "${playerctl} next"})" { locked = true; })
              (mkBindWith "XF86AudioPrev" "hl.dsp.exec_cmd(${luaString "${playerctl} previous"})" {
                locked = true;
              })
              (mkBindWith "XF86AudioPlay" "hl.dsp.exec_cmd(${luaString "${playerctl} play-pause"})" {
                locked = true;
              })
              (mkBindWith "XF86AudioStop" "hl.dsp.exec_cmd(${luaString "${playerctl} stop"})" { locked = true; })
              (mkExec "ALT + XF86AudioNext" "${playerctld} shift")
              (mkExec "ALT + XF86AudioPrev" "${playerctld} unshift")
              (mkExec "ALT + XF86AudioPlay" "systemctl --user restart playerctld")
            ]
          );
        # Organizing workspaces between 2 monitors. First 5 in Lg Ultrawide Monitor .
        monitor = [
          {
            output = "DP-1";
            mode = "3440x1440@100";
            position = "0x0";
            scale = 1;
            bitdepth = 10;
            cm = "auto";
          }
          {
            output = "eDP-1";
            mode = "1920x1080@120";
            position = "3440x0";
            scale = 1;
          }
        ];
        workspace_rule =
          map (x: {
            workspace = toString x;
            monitor = "DP-1";
          }) (lib.genList (x: x + 1) 5) # Workspace 1 - 5 in LG Monitor
          ++ map (x: {
            workspace = toString x;
            monitor = "eDP-1";
          }) (lib.genList (x: x + 6) 5); # Workspace 6 - 10 in Laptop
      };
    submaps =
      let
        lua = lib.generators.mkLuaInline;
        mkBind = key: dispatcher: {
          _args = [
            key
            (lua dispatcher)
          ];
        };
        mkBindWith = key: dispatcher: opts: {
          _args = [
            key
            (lua dispatcher)
            opts
          ];
        };
      in
      {
        resize = {
          settings = {
            bind = [
              (mkBindWith "right" "hl.dsp.window.resize({ x = 10, y = 0, relative = true })" {
                repeating = true;
              })
              (mkBindWith "left" "hl.dsp.window.resize({ x = -10, y = 0, relative = true })" {
                repeating = true;
              })
              (mkBindWith "up" "hl.dsp.window.resize({ x = 0, y = -10, relative = true })" { repeating = true; })
              (mkBindWith "down" "hl.dsp.window.resize({ x = 0, y = 10, relative = true })" { repeating = true; })
              (mkBind "escape" ''hl.dsp.submap("reset")'')
            ];
          };
        };
        passthrough = {
          settings = {
            bind = [
              (mkBind "SUPER + P" ''hl.dsp.submap("reset")'')
            ];
          };
        };
      };
    extraConfig = "";
  };
}
