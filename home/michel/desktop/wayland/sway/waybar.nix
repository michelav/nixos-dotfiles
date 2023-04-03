{ pkgs, lib, config, ... }:
let waybar-with-mp = pkgs.waybar.override { withMediaPlayer = true; };
in {
  programs.waybar = {
    enable = true;
    package = waybar-with-mp;
    settings = [{
      output = "eDP-1";
      layer = "top";
      position = "top";
      # margin = "8";
      modules-left =
        [ "custom/scratchpad" "sway/workspaces" "sway/mode" "custom/media" ];
      modules-center = [ "clock" ];
      modules-right = [
        "idle_inhibitor"
        "backlight"
        "pulseaudio"
        "network"
        "battery"
        "tray"
      ];

      "sway/workspaces" = {
        disable-scroll = true;
        all-outputs = true;
        format = "{icon}";
        format-icons = {
          "1" = "";
          "2" = "";
          "3" = "";
          "4" = "";
          "5" = "";
          "6" = "";
          "7" = "";
          "8" = "";
          "9" = "";
          "10" = "";
          focused = "";
          urgent = "";
          default = "";
        };
      };

      # TODO: Comment out after helvum build is fixed

      /* "wireplumber" = {
           format = "{volume}%";
           format-muted = "";
           on-click = "helvum";
           format-icons = [ "" "" "" ];
         };
      */

      "custom/media" = {
        format = "{icon} {}";
        # format-icons = {
        #     "Playing" = " ";
        #     "Paused" = " ";
        # };
        # max-length = 70;
        escape = true;
        return-type = "json";
        max-length = 40;
        on-click = "playerctl play-pause";
        on-click-right = "playerctl stop";
        smooth-scrolling-threshold =
          5; # This value was tested using a trackpad, it should be lowered if using a mouse.
        on-scroll-up = "playerctl next";
        on-scroll-down = "playerctl previous";
        exec =
          "${waybar-with-mp}/bin/waybar-mediaplayer.py 2>/dev/null"; # Script in resources/custom_modules folder
        # "exec" = "playerctl -a metadata --format '{\"text\": \"{{playerName}}: {{artist}} - {{markup_escape(title)}}\", \"tooltip\": \"{{playerName}} : {{markup_escape(title)}}\", \"alt\": \"{{status}}\", \"class\": \"{{status}}\"}' -F";
      };
      "custom/scratchpad" = {
        interval = 1;
        exec =
          "swaymsg -t get_tree | jq 'recurse(.nodes[]) | first(select(.name==\"__i3_scratch\")) | .floating_nodes | length'";
        format = "  {}";
        tooltip = false;
        on-click = "swaymsg 'scratchpad show'";
        on-click-right = "swaymsg 'move scratchpad'";
      };
      "tray" = {
        icon-size = 12;
        spacing = 10;
      };
      "backlight" = {
        "tooltip" = false;
        "format" = " {}%";
        "interval" = 1;
        "on-scroll-up" = "light -A 5";
        "on-scroll-down" = "light -U 5";
      };

      "network" = {
        format-wifi = "{essid} ({signalStrength}%) ";
        format-ethernet = "{ipaddr}/{cidr} ";
        format-linked = "(No IP) ";
        format-disconnected = "Disconnected ";
        format-alt = "{bandwidthDownBits}/{bandwidthUpBits}";
        on-click-middle = "nmtui";
        tooltip-format-wifi = "{ipaddr}/{cidr}";
        tooltip-format-ethernet = "{ifname}";
      };

      "idle_inhibitor" = {
        format = "{icon}";
        format-icons = {
          activated = "";
          deactivated = "";
        };
        tooltip-format-activated = "idle disabled";
        tooltip-format-deactivated = "idle enabled";
      };
      "pulseaudio" = {
        scroll-step = 1;
        format = "{volume}% {icon} {format_source}";
        format-bluetooth = "{volume}% {icon} {format_source}";
        format-bluetooth-muted = " {icon} {format_source}";
        format-muted = " {format_source}";
        format-source = "{volume}% ";
        format-source-muted = "";
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = [ "" "" "" ];
        };
        on-click = "pavucontrol";
      };
      "battery" = {
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{capacity}% {icon} ";
        format-charging = "{capacity}% ";
        format-plugged = "{capacity}% ";
        format-alt = "{time} {icon}";
        format-icons = [ "" "" "" "" "" ];
      };
      "clock" = {
        #format = "{:  %H:%M %p   %d/%m/%Y}";
        format = "{: %a, %d/%m/%Y  %H:%M}";
        tooltip-format = ''
          <big>{:%Y %B}</big>
          <tt><small>{calendar}</small></tt>'';
      };
    }];
    style = import ./style.nix { inherit config; };
  };
}
