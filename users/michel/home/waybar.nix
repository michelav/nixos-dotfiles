{ pkgs, lib, config, ... }:
let
  scripts = ./scripts;
in
{
  programs.waybar = {
    enable = true;
    settings = [{
      output = "eDP-1";
      layer = "top";
      # position = "top";
      # margin = "8";
      modules-left = [
        # "custom/scratchpad"
        "sway/workspaces"
        "sway/mode"
        "custom/media"
      ];
      modules-center = [ "sway/window" ];
      modules-right = [
        "tray"
        "idle_inhibitor"
        "pulseaudio"
        "backlight"
        "battery"
        "bluetooth"
        "network"
        "clock"
      ];

      "sway/workspaces" = {
        all-outputs = true;
        format = "{icon}";
        format-icons = {
          "1" = "";
          "2" = "";
          "3" = "";
          "4" = "";
          "5" = "";
          "6" = "";
          "7" = "";
          "9" = "";
          "10" = "";
          focused = "";
          urgent = "";
          default = "";
        };
      };
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
          interval = 30; # Remove this if your script is endless and write in loop
          on-click = "playerctl -p spotify play-pause";
          on-click-right = "killall spotify";
          smooth-scrolling-threshold = 10; # This value was tested using a trackpad, it should be lowered if using a mouse.
          on-scroll-up = "playerctl -p spotify next";
          on-scroll-down = "playerctl -p spotify previous";
          exec = "$HOME/.config/waybar/mediaplayer.py 2> /dev/null"; # Script in resources/custom_modules folder
          exec-if = "pgrep spotify";
          # "exec" = "playerctl -a metadata --format '{\"text\": \"{{playerName}}: {{artist}} - {{markup_escape(title)}}\", \"tooltip\": \"{{playerName}} : {{markup_escape(title)}}\", \"alt\": \"{{status}}\", \"class\": \"{{status}}\"}' -F";
      };
      # "custom/scratchpad" = {
      #   interval = 1;
      #   exec = "swaymsg -t get_tree | jq 'recurse(.nodes[]) | first(select(.name==\"__i3_scratch\")) | .floating_nodes | length'";
      #   format = "  {}";
      #   tooltip = false;
      #   on-click = "swaymsg 'scratchpad show'";
      #   on-click-right = "swaymsg 'move scratchpad'";
      # };
      "tray" = {
        icon-size = 12;
        spacing = 10;
      };
      # "custom/pkgs" = {
      #   format = "{}";
      #   exec = "${scripts}/pkgs.sh";
      #   return-type = "json";
      #   tooltip = true;
      # };
      # "custom/bluetooth" = {
      #   format = "{}";
      #   format-alt = "{alt}";
      #   exec = "${scripts}/bluetooth.sh --show";
      #   on-click-right = "${scripts}/bluetooth.sh --toggle";
      #   return-type = "json";
      #   inteval = 5;
      # };
      "backlight" = {
        "tooltip" = false;
        "format" = " {}%";
        "interval" = 1;
        "on-scroll-up" = "light -A 5";
        "on-scroll-down" = "light -U 5";
	    };

     "sway/window" = {
      "format" = "{}";
      "max-length" = 50;
      };

      network = {
        format-wifi = "{essid} ({signalStrength}%) ";
        format-ethernet = "Ethernet ";
        format-linked = "Ethernet (No IP) ";
        format-disconnected = "Disconnected ";
        format-alt = "{bandwidthDownBits}/{bandwidthUpBits}";
        on-click-middle = "nm-connection-editor";
      };
      "idle_inhibitor" = {
        format = "{icon}";
        format-icons = {
          activated = "";
          deactivated = "";
        };
      };
      pulseaudio = {
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
     battery = {
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{capacity}% {icon}";
        format-charging = "{capacity}% ";
        format-plugged = "{capacity}% ";
        format-alt = "{time} {icon}";
        format-icons = [ "" "" "" "" "" ];
      };
      clock = {
        format = "{: %H:%M %p  %d/%m/%Y}";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      };
      # "mpd" = {
      #   format = "{stateIcon} {artist} - {title}";
      #   format-disconnected = "ﱙ";
      #   format-stopped = "";
      #   state-icons = {
      #     paused = "";
      #     playing = "";
      #   };
      #   max-length = 40;
      #   interval = 1;
      #   on-click = "${pkgs.mpc_cli}/bin/mpc toggle";
      #   on-click-right = "${pkgs.mpc_cli}/bin/mpc stop";
      #   on-scroll-up = "${pkgs.mpc_cli}/bin/mpc volume +1";
      #   on-scroll-down = "${pkgs.mpc_cli}/bin/mpc volume -1";
      # };
    }];
    style = import ./style.nix { inherit config; };
  };
}
