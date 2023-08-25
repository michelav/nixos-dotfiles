{ pkgs, config, ... }:
let
  custom-waybar = pkgs.waybar.override {
    withMediaPlayer = true;
    hyprlandSupport = true;
  };
in {
  programs.waybar = {
    enable = true;
    package = custom-waybar;
    settings = [{
      output = "eDP-1";
      mode = "dock";
      layer = "top";
      position = "top";
      modules-left = [
        # "custom/scratchpad"
        # "wlr/workspaces"
        "hyprland/workspaces"
        "hyprland/submap"
        "custom/media"
      ];
      modules-center = [ "clock" ];
      modules-right = [
        "idle_inhibitor"
        "backlight"
        "pulseaudio"
        "network"
        "battery"
        "tray"
      ];
      # TODO: Chage to hyprland/workspaces module
      # "wlr/workspaces" = {
      #   disable-scroll = true;
      #   all-outputs = true;
      #   on-click = "activate";
      # };
      "hyprland/workspaces" = {
        format = "{icon}";
        format-icons = {
          "1" = "1";
          "2" = "2";
          "3" = "3";
          "4" = "4";
          "5" = "5";
          "6" = "6";
          "7" = "7";
          "8" = "8";
          "9" = "9";
          "special" = " ";
        };
        # XXX: Not working as expected. Should be always visible
        persistent_workspaces = { "eDP-1" = -99; };
        show-special = true;
        on-click = "activate";
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
        on-click = "playerctl play-pause";
        on-click-right = "playerctl stop";
        smooth-scrolling-threshold =
          5; # This value was tested using a trackpad, it should be lowered if using a mouse.
        on-scroll-up = "playerctl next";
        on-scroll-down = "playerctl previous";
        exec =
          "${custom-waybar}/bin/waybar-mediaplayer.py 2>/dev/null"; # Script in resources/custom_modules folder
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
      # TODO: Show only network symbol. Adjust tooltip and click to show more info if necessary
      "network" = {
        format-wifi = "{essid} ({signalStrength}%)  ";
        format-ethernet = "{ipaddr}/{cidr}  ";
        format-linked = "(No IP)  ";
        format-disconnected = "Disconnected  ";
        format-alt = "{bandwidthDownBits}/{bandwidthUpBits}";
        on-click-middle = "nmtui";
        tooltip-format-wifi = "{ipaddr}/{cidr}";
        tooltip-format-ethernet = "{ifname}";
      };

      "idle_inhibitor" = {
        format = "{icon}";
        format-icons = {
          deactivated = "󰷛 ";
          activated = "󰍹 ";
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
        format-source-muted = " ";
        format-icons = {
          headphone = " ";
          hands-free = " ";
          headset = " ";
          phone = " ";
          portable = " ";
          car = " ";
          default = [ " " " " " " ];
        };
        on-click = "pavucontrol";
      };
      "battery" = {
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{capacity}% {icon}";
        format-charging = "{capacity}%  ";
        format-plugged = "{capacity}%  ";
        format-alt = "{time} {icon}";
        format-icons = [ " " " " " " " " " " ];
      };
      "clock" = {
        #format = "{:  %H:%M %p   %d/%m/%Y}";
        format = "{: %a, %d/%m/%Y  %H:%M}";
        tooltip-format = ''
          <big>{:%Y %B}</big>
          <tt><small>{calendar}</small></tt>'';
      };
    }];
    style = with config.colorscheme.colors;
      with config.userPrefs; # css
      ''

        @define-color warning #${base0A};
        @define-color critical #${base08};
        @define-color workspacesfocused_bg #${base00};
        @define-color workspacesfocused_fg #${base07};
        @define-color workspace-urgent #${base09};
        @define-color module-bg #${base03};
        @define-color module-bg-alt #${base02};
        @define-color module-fg #${base00};
        @define-color module-fg-alt #${base06};
        @define-color module-fg-anm #${base01};
        @define-color module-bg-gp1 #${base0B};
        @define-color module-bg-gp2 #${base0C};
        @define-color module-bg-gp3 #${base0D};
        @define-color module-bg-gp4 #${base0E};
        @define-color module-bg-gp5 #${base0F};

        * {
          border: none;
          border-radius: 3px;
          min-height: 0;
          margin: 0.2em 0.2em 0.1em 0.2em;
        }

        #waybar {
          background: none;
          color: @module-fg;
          font-family: '${fonts.regular.name}', '${fonts.monospace.name}';
          font-size: 12pt;
          font-weight: 500;
          opacity: 1.0;
        }

        /* Each module */
        #battery,
        #clock,
        #submap,
        #custom-media,
        #network,
        #pulseaudio,
        #idle_inhibitor,
        #tray,
        #wireplumber,
        #backlight {
          background: @module-bg;
          color: @module-fg;
          padding-left: 0.8em;
          padding-right: 0.8em;
        }

        /* Each module that should blink */
        #memory,
        #temperature,
        #battery {
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
        }

        /* Each critical module */
        #memory.critical,
        #cpu.critical,
        #temperature.critical,
        #battery.critical {
            background: @critical;
            color: @module-fg-anm;
        }

        /* Each critical that should blink */
        #memory.critical,
        #temperature.critical,
        #battery.critical.discharging {
            animation-name: blink-critical;
            animation-duration: 2s;
        }

        /* Each warning */
        #network.disconnected,
        #memory.warning,
        #cpu.warning,
        #temperature.warning,
        #battery.warning {
            background: @warning;
            color: @module-fg-anm;
        }

        /* Each warning that should blink */
        #battery.warning.discharging {
            animation-name: blink-warning;
            animation-duration: 3s;
        }

        #submap { /* Shown current Sway mode (resize etc.) */
          color: @module-fg;
          background: @warning;
        }

        /* Workspaces stuff */

        #workspaces {
          background: @module-bg;
        }

        #workspaces button,
        #workspaces button.persistent {
            font-weight: normal; /* Somewhy the bar-wide setting is ignored*/
            padding: 0 0.6em;
            background: none;
            margin: 2px;
        }

        #workspaces button.special,
        #workspaces button.focused,
        #workspaces button.active {
            /* background: @workspacesfocused_bg; */
            color: @module-fg;
            font-weight: bold;
        }

        #workspaces button.urgent {
            border-color: @workspace-urgent;
            color: @workspace-urgent;
        }

        #custom-media {
            padding: 0 0.6em;
        }

        #idle_inhibitor {
            font-weight: bold;
            padding: 0 0.6em;
            color: @module-fg;
        }

        #idle_inhibitor.activated {
          background: #${base09}
        }

        #idle_inhibitor.deactivated {
          background: @module-bg;
        }

        #bluetooth {
          background: @module-bg;
          font-size: 1.2em;
          font-weight: bold;
          padding: 0 0.6em;
        }

        @keyframes blink-warning {
            70% {
                color: @module-fg-alt;
            }

            to {
                color: @module-fg-anm;
                background-color: @warning;
            }
        }

        @keyframes blink-critical {
            70% {
              color: @module-fg-alt;
            }

            to {
                color: @module-fg-anm;
                background-color: @critical;
            }
        }
      '';
  };
}
