{ pkgs, config, ... }:
let
  inherit (config) userPrefs xdg;
  swaylock = "${pkgs.swaylock-effects}/bin/swaylock}";
  lockcmd = "${swaylock} -f -S";
  swayidle = "${pkgs.swayidle}/bin/swayidle";

  # currently, there is some friction between sway and gtk:
  # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
  # the suggested way to set gtk settings is with gsettings
  # for gsettings to work, we need to tell it where the schemas are
  # using the XDG_DATA_DIR environment variable
  # run at the end of sway config
  configure-gtk-sway = pkgs.writeTextFile {
    name = "configure-gtk-sway";
    destination = "/bin/configure-gtk-sway";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in with config.gtk; ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme '${theme.name}'
    '';
  };
in {
  imports = [ ./waybar.nix ];

  home = {
    packages = with pkgs; [
      libnotify
      fuzzel
      swaylock-effects
      wl-clipboard
      grim
      slurp
      configure-gtk-sway
      glib
    ];
    /* sessionVariables = {
         # wayland
         XDG_SESSION_DESKTOP = "sway";
       };
    */

  };

  wayland.windowManager.sway = {
    enable = true;
    extraOptions = [ "--unsupported-gpu" ];
    wrapperFeatures = {
      base = true;
      gtk = true;
    };
    extraConfig = ''
      exec configure-gtk-sway
    '';
    extraSessionCommands = ''
      eval $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
      export SSH_AUTH_SOCK
      export XDG_SESSION_DESKTOP=sway
    '';
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
        names = [ userPrefs.fonts.regular.name ];
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
      startup = [{
        command = "${swayidle} -w -C ${xdg.configHome}/swayidle/sway-config";
      }
      # Initial lock
      # { command = "${pkgs.swaylock-effects}/bin/swaylock -f -S"; }
        ];
    };
  };
}
