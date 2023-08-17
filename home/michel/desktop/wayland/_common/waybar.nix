{ pkgs, config, ... }:
let
  custom-waybar = (pkgs.waybar.overrideAttrs (oa: {
    mesonFlags = (oa.mesonFlags or [ ]) ++ [ "-Dexperimental=true" ];
  })).override { withMediaPlayer = true; };
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

      "hyprland/workspaces" = {
        disable-scroll = true;
        all-outputs = true;
        on-click = "activate";
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
    style = with config.colorscheme.colors;
      with config.userPrefs; # css
      ''

        @define-color warning #${base0A};
        @define-color critical #${base08};
        @define-color workspacesfocused_bg #${base00};
        @define-color workspacesfocused_fg #${base0B};
        @define-color workspace-urgent #${base09};
        @define-color module-bg #${base02};
        @define-color module-bg-alt #${base04};
        @define-color module-fg #${base05};
        @define-color module-fg-alt #${base00};
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
          font-weight: normal;

        }

        /* Each module */
        #custom-scratchpad,
        #battery,
        #clock,
        #cpu,
        #custom-layout,
        #memory,
        #submap,
        #custom-media,
        #network,
        #pulseaudio,
        #temperature,
        #idle_inhibitor,
        #window,
        #tray,
        #wireplumber,
        #backlight {
            padding-left: 0.8em;
            padding-right: 1.0em;
        }

        /* Each module that should blink */
        #submap,
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
        #submap,
        #battery.warning.discharging {
            animation-name: blink-warning;
            animation-duration: 3s;
        }

        #submap { /* Shown current Sway mode (resize etc.) */
          color: @module-fg;
          background: @module-bg;
        }

        /* Workspaces stuff */

        #workspaces {
          background: @module-bg;
        }

        #workspaces button {
            font-weight: normal; /* Somewhy the bar-wide setting is ignored*/
            padding: 0 0.6em;
            opacity: 0.3;
            background: none;
            font-size: 14pt;
            margin: 2px;
        }

        #workspaces button.focused,
        #workspaces button.active {
            background: @workspacesfocused_bg;
            color: @workspacesfocused_fg;
            opacity: 1;
            font-weight: 900;
        }

        #workspaces button.urgent {
            border-color: @workspace-urgent;
            color: @workspace-urgent;
            opacity: 1;
        }

        #window {
            margin-right: 40px;
            margin-left: 40px;
            font-weight: normal;
        }

        #custom-media {
            background: @module-bg-gp1;
            font-weight: bold;
            padding: 0 0.6em;
            color: @module-fg-alt;
        }

        #idle_inhibitor {
            font-weight: bold;
            padding: 0 0.6em;
            color: @module-fg-alt;
        }

        #idle_inhibitor.activated {
          background: #${base09}
        }

        #idle_inhibitor.deactivated {
          background: @module-bg-gp1;
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


        /* Group 0 */
        #clock,
        #tray {
          background: none;
          color: @module-fg;
          font-size: 14pt
        }

        #custom-scratchpad,
        #wireplumber
        {
          background: #${base07};
          color: @module-fg-alt;
        }

        #network {
          background: @module-bg-gp4;
          color: @module-fg-alt;
        }

        /* Group 2 */
        #pulseaudio {
          background: @module-bg-gp3;
          color: @module-fg-alt;
        }

        /* Group 4 */
        #memory,
        #cpu,
        #backlight {
          background: @module-bg-gp2;
          color: @module-fg-alt;
        }

        #battery {
        	background: @module-bg-gp5;
          color: @module-fg-alt;
        }
      '';
  };
}
