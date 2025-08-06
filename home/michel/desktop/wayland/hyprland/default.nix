{
  inputs,
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  inherit (inputs.hyprland.packages.${pkgs.system}) hyprland xdg-desktop-portal-hyprland;
  hyprw-contrib = inputs.hyprland-contrib.packages.${pkgs.system};
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
    package = hyprland;
    portalPackage = xdg-desktop-portal-hyprland;
    settings =
      let
        inherit (config.colorscheme) palette;
        inherit (config.home.sessionVariables) TERMINAL BROWSER EDITOR;
        uwsm = lib.getExe osConfig.programs.uwsm.package;
      in
      {
        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 1;
          "col.active_border" = "0xff${palette.base0C}";
          "col.inactive_border" = "0xff${palette.base02}";
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
          bezier = [
            "easein,0.11, 0, 0.5, 0"
            "easeout,0.5, 1, 0.89, 1"
            "easeinout,0.45, 0, 0.55, 1"
          ];
          animation = [
            "windowsIn,1,3,easeout,slide"
            "windowsOut,1,3,easein,slide"
            "windowsMove,1,3,easeout"
            "fadeIn,1,3,easeout"
            "fadeOut,1,3,easein"
            "fadeSwitch,1,3,easeout"
            "fadeShadow,1,3,easeout"
            "fadeDim,1,3,easeout"
            "border,1,3,easeout"
            "workspaces,1,2,easeout,slide"
          ];
        };
        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };
        master = {
          mfact = 0.6;
          orientation = "left";
        };
        misc = {
          vfr = "on";
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
        # Bindings
        bindm = [
          "SUPER,mouse:272,movewindow"
          "SUPER,mouse:273,resizewindow"
        ];
        bind =
          let
            cliphist = "${pkgs.cliphist}/bin/cliphist";
            wofi = "${pkgs.wofi}/bin/wofi";
            wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy";
            makoctl = "${pkgs.mako}/bin/makoctl";
            grimblast = "${hyprw-contrib.grimblast}/bin/grimblast";
            light = "${pkgs.light}/bin/light";
            wpctl = "${pkgs.wireplumber}/bin/wpctl";
            fuzzel = "${config.programs.fuzzel.package}/bin/fuzzel";
          in
          [
            # Basic bindings
            "SUPER,t,exec,${uwsm} app ${TERMINAL}"
            "SUPER,Return,exec,${uwsm} app ${TERMINAL}"
            # "SUPER,v,exec,${uwsm} app -- ${TERMINAL} $SHELL -ic ${EDITOR}"
            "SUPER,b,exec,${uwsm} app ${BROWSER}"
            "SUPER, v, exec, ${cliphist} list | ${wofi} --dmenu | ${cliphist} decode | ${wl-copy}"
            "SUPER,w,exec,${makoctl} dismiss"
            "SUPER,backspace,exec,loginctl lock-session"
            ",Print,exec,${grimblast} --notify copy output"
            "SHIFT,Print,exec,${grimblast} --notify copy active"
            "CONTROL,Print,exec,${grimblast} --notify copy screen"
            "SUPER,Print,exec,${grimblast} --notify copy window"
            "ALT,Print,exec,${grimblast} --notify copy area"
            # Desktop Launchers
            # "SUPER,x,exec,${wofi} -S drun -x 10 -y 10 -W 25% -H 60%"
            "SUPER,d,exec,${wofi} -f -S run"
            "SUPER,x,exec,${fuzzel} --launch-prefix='uwsm app --'"
            ",Scroll_Lock,exec,pass-wofi"
            ",XF86Calculator,exec,pass-wofi"
            # Laptop brightness
            ",XF86MonBrightnessUp,exec,${light} -A 10"
            ",XF86MonBrightnessDown,exec,${light} -U 10"
            # Audio controls
            ",XF86AudioRaiseVolume,exec,${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%+"
            ",XF86AudioLowerVolume,exec,${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%-"
            ",XF86AudioMute,exec,${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle"
            ",XF86AudioMicMute,exec,${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ]
          ++ [
            # Window controls
            "SUPERSHIFT,q,killactive"
            "SUPERSHIFT,e,exec,${uwsm} stop"
            "SUPER,s,togglesplit"
            "SUPER,f,fullscreen,1"
            "SUPERSHIFT,f,fullscreen,0"
            "SUPERSHIFT,space,togglefloating"
            "SUPER,minus,splitratio,-0.25"
            "SUPERSHIFT,minus,splitratio,-0.3333333"
            "SUPER,equal,splitratio,0.25"
            "SUPERSHIFT,equal,splitratio,0.3333333"
            "SUPER,g,togglegroup"
            "SUPER,apostrophe,changegroupactive,f"
            "SUPERSHIFT,apostrophe,changegroupactive,b"
            "SUPER,left,movefocus,l"
            "SUPER,right,movefocus,r"
            "SUPER,up,movefocus,u"
            "SUPER,down,movefocus,d"
            "SUPER,h,movefocus,l"
            "SUPER,l,movefocus,r"
            "SUPER,k,movefocus,u"
            "SUPER,j,movefocus,d"
            "SUPERSHIFT,left,movewindow,l"
            "SUPERSHIFT,right,movewindow,r"
            "SUPERSHIFT,up,movewindow,u"
            "SUPERSHIFT,down,movewindow,d"
            "SUPERSHIFT,h,movewindow,l"
            "SUPERSHIFT,l,movewindow,r"
            "SUPERSHIFT,k,movewindow,u"
            "SUPERSHIFT,j,movewindow,d"
            "SUPERCONTROL,1,focusmonitor,DP-1"
            "SUPERCONTROL,2,focusmonitor,eDP-1"
            "SUPERCONTROLSHIFT,left,movewindow,mon:l"
            "SUPERCONTROLSHIFT,right,movewindow,mon:r"
            "SUPERCONTROLSHIFT,up,movewindow,mon:u"
            "SUPERCONTROLSHIFT,down,movewindow,mon:d"
          ]
          ++
            # Workspace bindings
            (map (x: "SUPER,${toString x},workspace,${toString x}") (lib.genList (x: x + 1) 9))
          ++ [
            # Special workspace bindings
            "SUPER,u,togglespecialworkspace"
            "SUPERSHIFT,u,movetoworkspace,special"
            "SUPER,0,workspace,10"
          ]
          ++
            # Moving WIndows to Workspace bindings
            (map (x: "SUPERSHIFT,${toString x},movetoworkspacesilent,${toString x}") (lib.genList (x: x + 1) 9))
          ++ [ "SUPERSHIFT,0,movetoworkspacesilent,10" ]
          ++ (
            let
              playerctl = lib.getExe' config.services.playerctld.package "playerctl";
              playerctld = lib.getExe' config.services.playerctld.package "playerctld";
            in
            lib.optionals config.services.playerctld.enable [
              # media controls
              ",XF86AudioNext,exec,${playerctl} next"
              ",XF86AudioPrev,exec,${playerctl} previous"
              ",XF86AudioPlay,exec,${playerctl} play-pause"
              ",XF86AudioStop,exec,${playerctl} stop"
              "ALT,XF86AudioNext,exec,${playerctld} shift"
              "ALT,XF86AudioPrev,exec,${playerctld} unshift"
              "ALT,XF86AudioPlay,exec,systemctl --user restart playerctld"
            ]
          );
        # Organizing workspaces between 2 monitors. First 5 in Lg Ultrawide Monitor .
        monitor = [
          "DP-1, 3440x1440@100, 0x0, 1"
          "eDP-1, 1920x1080@120, 3440x0, 1"
        ];
        workspace =
          map (x: "${toString x}, monitor:DP-1") (lib.genList (x: x + 1) 5) # Workspace 1 - 5 in LG Monitor
          ++ map (x: "${toString x}, monitor:eDP-1") (lib.genList (x: x + 6) 5); # Workspace 6 - 10 in Laptop
      };
    extraConfig = ''
      # Resize Submap
      # will switch to a submap called resize
      bind=SUPERSHIFT,r,submap,resize
      # will start a submap called "resize"
      submap=resize
      # sets repeatable binds for resizing the active window
      binde=,right,resizeactive,10 0
      binde=,left,resizeactive,-10 0
      binde=,up,resizeactive,0 -10
      binde=,down,resizeactive,0 10
      # use reset to go back to the global submap
      bind=,escape,submap,reset 
      # will reset the submap, meaning end the current one and return to the global one
      submap=reset
      # Passthrough mode (e.g. for VNC)
      bind=SUPER,P,submap,passthrough
      submap=passthrough
      bind=SUPER,P,submap,reset
      submap=reset
    '';
  };
}
