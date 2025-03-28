{
  config,
  pkgs,
  gtk-config,
  osConfig,
  ...
}:
# TODO: Remove this file as soon as hyprland config gets stable
let
  inherit (config.home.sessionVariables) TERMINAL BROWSER EDITOR;
  inherit (config) colorscheme;
  inherit (config.userPrefs) wallpaper;
  cliphist = "${pkgs.cliphist}/bin/cliphist";
  wl-paste = "${pkgs.wl-clipboard}/bin/wl-paste";
  cursor_size = "${toString config.home.pointerCursor.size}";
  env_nvidia =
    if osConfig.hardware.nvidia.prime.offload.enable then
      ""
    else
      ''
        env=LIBVA_DRIVER_NAME,nvidia
        env=GBM_BACKEND,nvidia-drm
        env=__GLX_VENDOR_LIBRARY_NAME,nvidia
      '';
in
''
  monitor=DP-1, 3440x1440@144, 0x0, 1
  monitor=eDP-1, 1920x1080@120, 3440x0, 1
  env=XDG_CURRENT_DESKTOP,Hyprland
  env=XDG_SESSION_DESKTOP,Hyprland
  env=GTK_THEME,${config.gtk.theme.name}
  env=HYPRCURSOR_THEME,Bibata-modern
  env=HYPRCURSOR_SIZE,${cursor_size}
  ${env_nvidia}

  general {
      gaps_in=5
      gaps_out=10
      border_size=1
      col.active_border=0xff${colorscheme.palette.base0C}
      col.inactive_border=0xff${colorscheme.palette.base02}
      layout=master
      # col.group_border_active=0xff${colorscheme.palette.base0B}
      # col.group_border=0xff${colorscheme.palette.base04}
  }
  cursor {
    inactive_timeout=5
    no_hardware_cursors=true
    enable_hyprcursor=true
  }
  decoration {
    active_opacity=0.94
    inactive_opacity=0.84
    fullscreen_opacity=1.0
    rounding=5
    shadow {
      enabled=true
      range=12
      offset=3 3
      color=0x44000000
      color_inactive=0x66000000
    }
    blur {
      enabled=true
      size=5
      passes=3
      ignore_opacity=true
    }
  }
  animations {
    enabled=true
    bezier=easein,0.11, 0, 0.5, 0
    bezier=easeout,0.5, 1, 0.89, 1
    bezier=easeinout,0.45, 0, 0.55, 1
    animation=windowsIn,1,3,easeout,slide
    animation=windowsOut,1,3,easein,slide
    animation=windowsMove,1,3,easeout
    animation=fadeIn,1,3,easeout
    animation=fadeOut,1,3,easein
    animation=fadeSwitch,1,3,easeout
    animation=fadeShadow,1,3,easeout
    animation=fadeDim,1,3,easeout
    animation=border,1,3,easeout
    animation=workspaces,1,2,easeout,slide
  }
  dwindle {
    pseudotile=true
    preserve_split=true
  }
  master {
    mfact=0.4
    orientation=center
    always_center_master=true
  }
  misc {
    vfr=on
    disable_hyprland_logo=true
    disable_splash_rendering=true
  }
  input {
    kb_layout=us,br
    kb_variant=intl,
    kb_options = grp:alt_altgr_toggle
    touchpad {
      disable_while_typing=false
    }
  }
  # Startup
  exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
  exec-once=waybar
  exec=swaybg -i ${wallpaper} --mode fill
  exec=${gtk-config}/bin/gtk-config
  exec-once=mako
  #clipboard management
  exec-once = ${wl-paste} --type text --watch ${cliphist} store #Stores only text data
  exec-once = ${wl-paste} --type image --watch ${cliphist} store #Stores only image data
  bind = SUPER, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy
  # Mouse binding
  bindm=SUPER,mouse:272,movewindow
  bindm=SUPER,mouse:273,resizewindow
  # Program bindings
  bind=SUPER,Return,exec,${TERMINAL}
  bind=SUPER,w,exec,makoctl dismiss
  bind=SUPER,q,exec,pkill -USR1 waybar
  bind=SUPER,v,exec,${TERMINAL} $SHELL -ic ${EDITOR}
  bind=SUPER,b,exec,${BROWSER}
  bind=SUPER,x,exec,wofi -S drun -x 10 -y 10 -W 25% -H 60%
  bind=SUPER,d,exec,wofi -f -S run
  bind=,Scroll_Lock,exec,pass-wofi # fn+k
  bind=,XF86Calculator,exec,pass-wofi # fn+f12
  # Toggle waybar
  bind=,XF86Tools,exec,pkill -USR2 waybar # profile button
  # Lock screen
  bind=SUPER,backspace,exec,loginctl lock-session
  # Screenshots
  bind=,Print,exec,grimblast --notify copy output
  bind=SHIFT,Print,exec,grimblast --notify copy active
  bind=CONTROL,Print,exec,grimblast --notify copy screen
  bind=SUPER,Print,exec,grimblast --notify copy window
  bind=ALT,Print,exec,grimblast --notify copy area
  # Keyboard controls (brightness, media, sound, etc)
  bind=,XF86MonBrightnessUp,exec,light -A 10
  bind=,XF86MonBrightnessDown,exec,light -U 10
  bind=,XF86AudioNext,exec,playerctl next
  bind=,XF86AudioPrev,exec,playerctl previous
  bind=,XF86AudioPlay,exec,playerctl play-pause
  bind=,XF86AudioStop,exec,playerctl stop
  bind=ALT,XF86AudioNext,exec,playerctld shift
  bind=ALT,XF86AudioPrev,exec,playerctld unshift
  bind=ALT,XF86AudioPlay,exec,systemctl --user restart playerctld
  bind=,XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
  bind=,XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
  bind=,XF86AudioMute,exec,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
  bind=SHIFT,XF86AudioMute,exec,pactl set-source-mute @DEFAULT_SOURCE@ toggle
  bind=,XF86AudioMicMute,exec,wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
  # Window manager controls
  bind=SUPERSHIFT,q,killactive
  bind=SUPERSHIFT,e,exit
  bind=SUPER,s,togglesplit
  bind=SUPER,f,fullscreen,1
  bind=SUPERSHIFT,f,fullscreen,0
  bind=SUPERSHIFT,space,togglefloating
  bind=SUPER,minus,splitratio,-0.25
  bind=SUPERSHIFT,minus,splitratio,-0.3333333
  bind=SUPER,equal,splitratio,0.25
  bind=SUPERSHIFT,equal,splitratio,0.3333333
  bind=SUPER,g,togglegroup
  bind=SUPER,apostrophe,changegroupactive,f
  bind=SUPERSHIFT,apostrophe,changegroupactive,b
  bind=SUPER,left,movefocus,l
  bind=SUPER,right,movefocus,r
  bind=SUPER,up,movefocus,u
  bind=SUPER,down,movefocus,d
  bind=SUPER,h,movefocus,l
  bind=SUPER,l,movefocus,r
  bind=SUPER,k,movefocus,u
  bind=SUPER,j,movefocus,d
  bind=SUPERSHIFT,left,movewindow,l
  bind=SUPERSHIFT,right,movewindow,r
  bind=SUPERSHIFT,up,movewindow,u
  bind=SUPERSHIFT,down,movewindow,d
  bind=SUPERSHIFT,h,movewindow,l
  bind=SUPERSHIFT,l,movewindow,r
  bind=SUPERSHIFT,k,movewindow,u
  bind=SUPERSHIFT,j,movewindow,d
  bind=SUPERCONTROL,left,focusmonitor,l
  bind=SUPERCONTROL,right,focusmonitor,r
  bind=SUPERCONTROL,up,focusmonitor,u
  bind=SUPERCONTROL,down,focusmonitor,d
  bind=SUPERCONTROL,h,focusmonitor,l
  bind=SUPERCONTROL,l,focusmonitor,r
  bind=SUPERCONTROL,k,focusmonitor,u
  bind=SUPERCONTROL,j,focusmonitor,d
  bind=SUPERCONTROL,1,focusmonitor,DP-1
  bind=SUPERCONTROL,2,focusmonitor,DP-2
  bind=SUPERCONTROL,3,focusmonitor,DP-3
  bind=SUPERCONTROLSHIFT,left,movewindow,mon:l
  bind=SUPERCONTROLSHIFT,right,movewindow,mon:r
  bind=SUPERCONTROLSHIFT,up,movewindow,mon:u
  bind=SUPERCONTROLSHIFT,down,movewindow,mon:d
  bind=SUPERCONTROLSHIFT,h,movewindow,mon:l
  bind=SUPERCONTROLSHIFT,l,movewindow,mon:r
  bind=SUPERCONTROLSHIFT,k,movewindow,mon:u
  bind=SUPERCONTROLSHIFT,j,movewindow,mon:d
  bind=SUPERCONTROLSHIFT,1,movewindow,mon:DP-1
  bind=SUPERCONTROLSHIFT,2,movewindow,mon:DP-2
  bind=SUPERCONTROLSHIFT,3,movewindow,mon:DP-3
  bind=SUPERALT,left,movecurrentworkspacetomonitor,l
  bind=SUPERALT,right,movecurrentworkspacetomonitor,r
  bind=SUPERALT,up,movecurrentworkspacetomonitor,u
  bind=SUPERALT,down,movecurrentworkspacetomonitor,d
  bind=SUPERALT,h,movecurrentworkspacetomonitor,l
  bind=SUPERALT,l,movecurrentworkspacetomonitor,r
  bind=SUPERALT,k,movecurrentworkspacetomonitor,u
  bind=SUPERALT,j,movecurrentworkspacetomonitor,d

  # WORKSPACES

  workspace = 1, monitor:DP-1
  workspace = 2, monitor:DP-1
  workspace = 3, monitor:DP-1
  workspace = 4, monitor:DP-1
  workspace = 5, monitor:DP-1
  workspace = 6, monitor:eDP-1
  workspace = 7, monitor:eDP-1
  workspace = 8, monitor:eDP-1
  workspace = 9, monitor:eDP-1
  workspace = 10, monitor:eDP-1
  bind=SUPER,u,togglespecialworkspace
  bind=SUPERSHIFT,u,movetoworkspace,special
  bind=SUPER,1,workspace,01
  bind=SUPER,2,workspace,02
  bind=SUPER,3,workspace,03
  bind=SUPER,4,workspace,04
  bind=SUPER,5,workspace,05
  bind=SUPER,6,workspace,06
  bind=SUPER,7,workspace,07
  bind=SUPER,8,workspace,08
  bind=SUPER,9,workspace,09
  bind=SUPER,0,workspace,10
  bind=SUPER,f1,workspace,11
  bind=SUPER,f2,workspace,12
  bind=SUPER,f3,workspace,13
  bind=SUPER,f4,workspace,14
  bind=SUPER,f5,workspace,15
  bind=SUPER,f6,workspace,16
  bind=SUPER,f7,workspace,17
  bind=SUPER,f8,workspace,18
  bind=SUPER,f9,workspace,19
  bind=SUPER,f10,workspace,20
  bind=SUPER,f11,workspace,21
  bind=SUPER,f12,workspace,22
  bind=SUPERSHIFT,1,movetoworkspacesilent,01
  bind=SUPERSHIFT,2,movetoworkspacesilent,02
  bind=SUPERSHIFT,3,movetoworkspacesilent,03
  bind=SUPERSHIFT,4,movetoworkspacesilent,04
  bind=SUPERSHIFT,5,movetoworkspacesilent,05
  bind=SUPERSHIFT,6,movetoworkspacesilent,06
  bind=SUPERSHIFT,7,movetoworkspacesilent,07
  bind=SUPERSHIFT,8,movetoworkspacesilent,08
  bind=SUPERSHIFT,9,movetoworkspacesilent,09
  bind=SUPERSHIFT,0,movetoworkspacesilent,10
  bind=SUPERSHIFT,f1,movetoworkspacesilent,11
  bind=SUPERSHIFT,f2,movetoworkspacesilent,12
  bind=SUPERSHIFT,f3,movetoworkspacesilent,13
  bind=SUPERSHIFT,f4,movetoworkspacesilent,14
  bind=SUPERSHIFT,f5,movetoworkspacesilent,15
  bind=SUPERSHIFT,f6,movetoworkspacesilent,16
  bind=SUPERSHIFT,f7,movetoworkspacesilent,17
  bind=SUPERSHIFT,f8,movetoworkspacesilent,18
  bind=SUPERSHIFT,f9,movetoworkspacesilent,19
  bind=SUPERSHIFT,f10,movetoworkspacesilent,20
  bind=SUPERSHIFT,f11,movetoworkspacesilent,21
  bind=SUPERSHIFT,f12,movetoworkspacesilent,22
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
''
