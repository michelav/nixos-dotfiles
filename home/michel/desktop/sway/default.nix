{ pkgs, config, ... }:
let
  lockcmd = "swaylock -f -S";
  #   "swaylock -f --screenshots --clock --indicator --indicator-radius 100 --indicator-thickness 7 --effect-blur 7x5 --effect-vignette 0.5:0.5 --ring-color 192330 --key-hl-color 9d79d6 --line-color 000000 --inside-color c94f6d --separator-color 000000 --grace 3 --fade-in 0.5 --effect-greyscale -d";
  # Script to let dbus know about important env variables and
  # propogate them to relevent services run at the end of sway config
  # see
  # https://github.com/emersion/xdg-desktop-portal-wlr/wiki/"It-doesn't-work"-Troubleshooting-Checklist
  # note: this is pretty much the same as  /etc/sway/config.d/nixos.conf but also restarts  
  # some user services to make sure they have the correct environment variables
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;
    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };

  # currently, there is some friction between sway and gtk:
  # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
  # the suggested way to set gtk settings is with gsettings
  # for gsettings to work, we need to tell it where the schemas are
  # using the XDG_DATA_DIR environment variable
  # run at the end of sway config
  configure-gtk-sway = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk-sway";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme 'Catppuccin-red-dark'
      gsettings set $gnome_schema icon-theme 'Nordzy-dark'
      gsettings set $gnome_schema cursor-theme 'Nordzy-white-cursors'
    '';
  };
in {
  imports = [
    ../common
    ./waybar.nix
    ./mako.nix
    ./swayidle.nix
    ./swaylock.nix
    ./gammastep.nix
  ];

  home = {
    packages = with pkgs; [
      libnotify
      fuzzel
      swayidle
      swaylock-effects
      waybar
      wl-clipboard
      grim
      slurp
      wofi
      dbus-sway-environment
      configure-gtk-sway
      glib
    ];
    sessionVariables = {
      # wayland
      XDG_DESKTOP_SESSION = "sway";
      XDG_SESSION_TYPE = "wayland";
      LIBSEAT_BACKEND = "logind";
    };

  };

  wayland.windowManager.sway = {
    enable = true;
    extraOptions = [ "--unsupported-gpu" ];
    wrapperFeatures = {
      base = true;
      gtk = true;
    };
    config = rec {
      terminal = "kitty";
      input = {
        "type:keyboard" = {
          xkb_layout = "br";
          xkb_model = "abnt2";
        };
        "1739:32552:MSFT0001:01_06CB:7F28_Touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
          middle_emulation = "enabled";
          tap_button_map = "lrm";
        };
      };
      output."eDP-1".bg = " ~/Pictures/wallpapers/ign_endeavour2.png fill";
      fonts = {
        names = [ config.desktop.fonts.regular.name ];
        size = 12.0;
      };
      gaps = {
        inner = 5;
        outer = 2;
      };
      window = {
        titlebar = false;
        # border = 2;
        commands = [
          {
            command = "move scratchpad";
            criteria = { title = "Firefox — Sharing Indicator"; };
          }
          {
            command = "move scratchpad";
            criteria = { app_id = "transmission-gtk"; };
          }
        ];
      };
      floating = {
        border = 2;
        criteria = [
          { app_id = "org.keepassxc.KeePassXC"; }
          {
            class = "firefox";
            title = "Picture-in-Picture";
          }
          { app_id = "mpv"; }
          { app_id = "spotify"; }
        ];
      };
      modifier = "Mod4";
      keybindings =
        import ./sway-kb.nix { inherit modifier terminal lockcmd pkgs config; };
      modes = {
        resize = {
          "h" = "resize shrink width 50 px";
          "j" = "resize grow height 50 px";
          "k" = "resize shrink height 50 px";
          "l" = "resize grow width 50 px";
          "Escape" = "mode default";
          "Return" = "mode default";
        };
        passthrough = { "${modifier}+F11" = "mode default"; };
      };
      bars = [{ command = "waybar"; }];
      colors = import ./colors.nix { inherit (config.colorscheme) colors; };
    };

    extraConfig = ''
      exec systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP SWAYSOCK
    '';

    extraSessionCommands = ''
      export MOZ_ENABLE_WAYLAND="1"
      export GDK_BACKEND=wayland
      export WLR_NO_HARDWARE_CURSORS="1"
      export XDG_SESSION_TYPE=wayland
      export XDG_SESSION_DESKTOP=sway
      export XDG_CURRENT_DESKTOP=sway
      export SDL_VIDEODRIVER=wayland
    '';
  };
}
