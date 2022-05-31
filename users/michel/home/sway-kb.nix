{ modifier, terminal, lockcmd, pkgs, config, ... }:
let
  inherit (config.colorscheme) colors;
in
{
  # open terminal
  "${modifier}+Return" = "exec ${terminal}";

  # open launcher
  "${modifier}+d" = ''exec ${toString [
    "${pkgs.fuzzel}/bin/fuzzel -P 'run: '"
    "-f '${config.gtk.font.name}:size=10' -i '${config.gtk.iconTheme.name}'"
    "-r 2 -B 3 -y 20 -p 10"
    "-b '${colors.base00}ff' -t '${colors.base06}ff'"
    "-C '${colors.base0D}ff' -m '${colors.base08}ff'"
    "-s '${colors.base02}ff' -S '${colors.base06}ff'"
  ]}'';

  # function keybindings
  "${modifier}+F1" = "exec ${config.home.sessionVariables.BROWSER}";

  "${modifier}+Shift+q" = "kill";

  "${modifier}+l" = "exec ${lockcmd}";

  "${modifier}+Left" = "focus left";
  "${modifier}+Down" = "focus down";
  "${modifier}+Up" = "focus up";
  "${modifier}+Right" = "focus right";
  "${modifier}+Shift+h" = "move left 20";
  "${modifier}+Shift+j" = "move down 20";
  "${modifier}+Shift+k" = "move up 20";
  "${modifier}+Shift+l" = "move right 20";

  "${modifier}+f" = "fullscreen toggle";
  "${modifier}+Shift+space" = "floating toggle";
  "${modifier}+space" = "focus mode_toggle";

  # modes
  "${modifier}+r" = "mode resize";
  "${modifier}+F11" = "mode passthrough";

  "${modifier}+1" = "workspace number 1";
  "${modifier}+2" = "workspace number 2";
  "${modifier}+3" = "workspace number 3";
  "${modifier}+4" = "workspace number 4";
  "${modifier}+5" = "workspace number 5";
  "${modifier}+6" = "workspace number 6";
  "${modifier}+7" = "workspace number 7";
  "${modifier}+8" = "workspace number 8";
  "${modifier}+9" = "workspace number 9";
  "${modifier}+Shift+1" = "move container to workspace number 1";
  "${modifier}+Shift+2" = "move container to workspace number 2";
  "${modifier}+Shift+3" = "move container to workspace number 3";
  "${modifier}+Shift+4" = "move container to workspace number 4";
  "${modifier}+Shift+5" = "move container to workspace number 5";
  "${modifier}+Shift+6" = "move container to workspace number 6";
  "${modifier}+Shift+7" = "move container to workspace number 7";
  "${modifier}+Shift+8" = "move container to workspace number 8";
  "${modifier}+Shift+9" = "move container to workspace number 9";

  # scratchpad
  "${modifier}+Shift+minus" = "move scratchpad";
  "${modifier}+minus" = "scratchpad show";

  "XF86AudioMute" = "exec ${pkgs.pamixer}/bin/pamixer -t";
  "XF86AudioRaiseVolume" = "exec ${pkgs.pamixer}/bin/pamixer -i 5";
  "XF86AudioLowerVolume" = "exec ${pkgs.pamixer}/bin/pamixer -d 5";
  "Shift+XF86AudioMute" = "exec ${pkgs.pamixer}/bin/pamixer --default-source -t";
  "Shift+XF86AudioRaiseVolume" = "exec ${pkgs.pamixer}/bin/pamixer --default-source -i 5";
  "Shift+XF86AudioLowerVolume" = "exec ${pkgs.pamixer}/bin/pamixer --default-source -d 5";

  "Print" = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot --notify save screen ${config.xdg.userDirs.pictures}/$(date +%m-%d-%Y_%H-%M-%S).jpg";
  "Shift+Print" = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot --notify save window ${config.xdg.userDirs.pictures}/$(date +%m-%d-%Y_%H-%M-%S).jpg";
  "Control+Shift+Print" = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot --notify save area ${config.xdg.userDirs.pictures}/$(date +%m-%d-%Y_%H-%M-%S).jpg";

  "XF86AudioPlay" = "exec ${pkgs.mpc_cli}/bin/mpc toggle";
  "XF86AudioPause" = "exec ${pkgs.mpc_cli}/bin/mpc toggle";
  "XF86AudioNext" = "exec ${pkgs.mpc_cli}/bin/mpc next";
  "XF86AudioPrev" = "exec ${pkgs.mpc_cli}/bin/mpc prev";
  "Shift+XF86AudioNext" = "exec ${pkgs.mpc_cli}/bin/mpc seek +10";
  "Shift+XF86AudioPrev" = "exec ${pkgs.mpc_cli}/bin/mpc seek -10";

  "XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 5";
  "XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U 5";

  # toggle waybar
  # "${modifier}+b" = "exec pkill -USR1 waybar";

  

  # layout
  "${modifier}+h" = "splith";
  "${modifier}+v" = "splitv";
  "${modifier}+b" = "splitt";
  "${modifier}+t" = "layout toggle";

  "${modifier}+s" = "layout stacking";
  "${modifier}+w" = "layout tabbed";
  "${modifier}+e" = "layout toggle split";

  "${modifier}+Shift+c" = "reload";
  "${modifier}+Shift+e" = "exec swaymsg exit";
}
