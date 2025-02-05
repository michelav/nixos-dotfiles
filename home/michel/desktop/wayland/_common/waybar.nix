{
  pkgs,
  config,
  inputs,
  ...
}:
let
  inherit (inputs.hyprland.packages.${pkgs.system}) hyprland;
  custom-waybar = pkgs.waybar.override {
    withMediaPlayer = true;
    hyprlandSupport = true;
    inherit hyprland;
  };
in
{
  programs.waybar = {
    enable = true;
    package = custom-waybar;
    settings = [
      {
        # output = "eDP-1";
        layer = "top";
        position = "top";
        modules-left = [
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
          "hyprland/language"
          "battery"
          "tray"
        ];
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
          persistent-workspaces = {
            "eDP-1" = -99;
          };
          show-special = true;
          on-click = "activate";
        };

        "custom/media" = {
          format = "{icon} {}";
          escape = true;
          return-type = "json";
          max-length = 40;
          on-click = "playerctl play-pause";
          on-click-right = "playerctl stop";
          smooth-scrolling-threshold = 5; # This value was tested using a trackpad, it should be lowered if using a mouse.
          on-scroll-up = "playerctl next";
          on-scroll-down = "playerctl previous";
          exec = "${custom-waybar}/bin/waybar-mediaplayer.py 2>/dev/null"; # Script in resources/custom_modules folder
        };
        "custom/scratchpad" = {
          interval = 1;
          exec = "swaymsg -t get_tree | jq 'recurse(.nodes[]) | first(select(.name==\"__i3_scratch\")) | .floating_nodes | length'";
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
          format-wifi = " ";
          format-ethernet = "󰈀";
          format-linked = "(No IP) 󰌷";
          format-disconnected = "Disconnected  ";
          format-alt = "{bandwidthDownBits}/{bandwidthUpBits}";
          on-click-middle = "nmtui";
          tooltip-format-wifi = "{essid} ({signalStrength}%) - {ipaddr}";
          tooltip-format-ethernet = "{ifname} - {ipaddr}/{cidr}";
        };
        # FIXME: Waybar or Hyprland not handling correctly US Intl Layout
        "hyprland/language" = {
          format-en = "EN";
          format-pt = "BR";
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
          format-source = " {volume}% ";
          format-source-muted = " ";
          format-icons = {
            headphone = "󰋋";
            hands-free = "󰋎";
            headset = "󰋎 ";
            phone = " ";
            portable = " ";
            car = " ";
            default = [
              " "
              " "
              " "
            ];
          };
          on-click = "pavucontrol";
        };
        "battery" = {
          states = {
            normal = 50;
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging-critical = "{capacity}% 󰢜 ";
          format-charging-warning = "{capacity}% 󰂇 ";
          format-charging-normal = "{capacity}% 󰢝 ";
          format-plugged = "{capacity}%  ";
          format-alt = "{time} {icon}";
          format-icons = [
            " "
            " "
            " "
            " "
            " "
          ];
        };
        "clock" = {
          mode = "year";
          format = "<big>󰃰</big>   {:%a, %d/%m/%Y  %H:%M}";
          timezone = "America/Fortaleza";
          locale = "pt_BR.utf8";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            on-click-right = "mode";
            format = with config.colorscheme.palette; {
              months = "<span color='#${base0B}'><b>{}</b></span>";
              days = "<span color='#${base04}'><b>{}</b></span>";
              weeks = "<span color='#${base0C}'><b>W{}</b></span>";
              weekdays = "<span color='#${base0A}'><b>{}</b></span>";
              today = "<span color='#${base08}'><b><u>{}</u></b></span>";
            };
          };
          tooltip-format = ''
            <big>{:%Y %B}</big>
            <tt>{calendar}</tt>'';
        };
      }
    ];
    style =
      with config.colorscheme.palette;
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
        #language,
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

  # systemd unit provided with the package is flawed.
  # TODO: Use provided systemd unit as soon this gets fixed.
  # Check: https://github.com/Alexays/Waybar/issues/1371
  systemd.user.services.mywaybar = {
    Unit = {
      Description = "Highly customizable Wayland bar for Sway and Wlroots based compositors.";
      Documentation = "man:waybar(5)";
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${custom-waybar}/bin/waybar";
      ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID";
      Restart = "on-failure";
      Slice = "app-graphical.slice";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
