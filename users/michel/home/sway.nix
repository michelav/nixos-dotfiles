{ pkgs, config, ... }:
let
  lockcmd = "swaylock -f --screenshots --clock --indicator --indicator-radius 100 --indicator-thickness 7 --effect-blur 7x5 --effect-vignette 0.5:0.5 --ring-color 192330 --key-hl-color 9d79d6 --line-color 000000 --inside-color c94f6d --separator-color 000000 --grace 3 --fade-in 0.5 --effect-greyscale -d";
in
{
  imports = [ ./services/swayidle.nix
              ./services/wlsunset.nix
              ./services/easyeffects.nix
            ];

  services.swayidle = {
    enable = true;
    lockcmd = lockcmd;
    debug = false;
  };

  # Sway Session Variables
  home = {
    packages = with pkgs; [
      libnotify
      fuzzel
      swayidle
      swaylock-effects
      wl-clipboard
      grim
      slurp
      mako
      wofi
    ];
    sessionVariables = {
      # wayland
      XDG_DESKTOP_SESSION = "sway";
      XDG_SESSION_TYPE = "wayland";
  };

  };


  wayland.windowManager.sway = {
    enable = true;
    extraOptions = [ "--unsupported-gpu" ];
    wrapperFeatures = { base = true; gtk = true; };
    config = rec {
      terminal = "alacritty";
      input = {
        "type:keyboard" = {
          xkb_layout = "br";
          xkb_model  = "abnt2";
        };
        "1739:32552:MSFT0001:01_06CB:7F28_Touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
          middle_emulation = "enabled";
          tap_button_map = "lmr";
        };
      };
      output."eDP-1".bg = " ~/Pictures/wallpapers/journey_middle_earth.png fill";
      fonts = {
         names = [ config.gtk.font.name ];
         size = 14.0;
      };
      gaps = {
        inner = 5;
        outer = 2;
      };
      window = {
        titlebar = false;
        # border = 2;
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
          {app_id = "spotify"; }
        ];
      };
      modifier = "Mod4";
      keybindings = import ./sway-kb.nix { inherit modifier terminal lockcmd pkgs config; };
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