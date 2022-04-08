{ pkgs, lib, config, ... }:
let
  scripts = ./scripts;
in
{
  programs.waybar = {
    enable = true;
    settings = [{
      output = "eDP-1";
      layer = "bottom";
      position = "top";
      margin = "8";
      modules-left = [
        "custom/scratchpad"
        "sway/workspaces"
        "sway/mode"
      ];
      modules-center = [ "mpd" ];
      modules-right = [
        "tray"
        "idle_inhibitor"
        "pulseaudio"
        "battery"
        "network"
        "clock"
      ];

      "sway/workspaces" = {
        format = "{name}";
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
        icon-size = 10;
        spacing = 6;
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
      "network" = {
        format = "🐑 {ipaddr}";
        format-disconnected = "🐑 Disconnected";
        format-alt = "⬆️ {bandwidthUpBits} ⬇️ {bandwidthDownBits}";
        tooltip-format = "{ifname}";
        max-length = 40;
        interval = 1;
      };
      "idle_inhibitor" = {
        format = "{icon}";
        format-icons = {
          activated = "🔓";
          deactivated = "🔒";
        };
      };
      "pulseaudio" = {
        format = "🐹 {volume}%";
        format-muted = "🐹 Muted";
        format-icons = {
          default = [ "奄" "奔" "墳" ];
        };
        on-click = "${pkgs.pamixer}/bin/pamixer -t";
        on-click-right = "${pkgs.pamixer}/bin/pamixer --default-source -t";
        scroll-step = 0.1;
      };
      "battery" = {
        format = "🐻 {capacity}%";
        format-plugged = "🐻 {capacity}%";
        interval = 5;
        states = {
          warning = 30;
          critical = 15;
        };
        max-length = 25;
      };
      "clock" = {
        format = "🐢 {:%H:%M}";
        format-alt = "🐢 {:%a, %d %b %Y}";
        tooltip-format = "<big>{:%Y %B}</big>\n<small>{calendar}</small>";
      };
      "mpd" = {
        format = "{stateIcon} {artist} - {title}";
        format-disconnected = "ﱙ";
        format-stopped = "";
        state-icons = {
          paused = "";
          playing = "";
        };
        max-length = 40;
        interval = 1;
        on-click = "${pkgs.mpc_cli}/bin/mpc toggle";
        on-click-right = "${pkgs.mpc_cli}/bin/mpc stop";
        on-scroll-up = "${pkgs.mpc_cli}/bin/mpc volume +1";
        on-scroll-down = "${pkgs.mpc_cli}/bin/mpc volume -1";
      };
    }];
    style = import ./style.nix { inherit config; };
  };
}
