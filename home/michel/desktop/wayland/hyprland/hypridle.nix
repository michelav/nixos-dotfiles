{ pkgs, inputs, ... }:
let
  inherit (inputs.hyprland.packages.${pkgs.system}) hyprland;
  hyprctl = "${hyprland}/bin/hyprctl";
  hyprlock = "${pkgs.hyprlock}/bin/hyprlock";
  pidof = "${pkgs.procps}/bin/pidof";
  bright = "${pkgs.light}/bin/light";
  isLocked = "${pidof} hyprlock";
  screenOn = "${hyprctl} dispatch dpms on";
  screenOff = "${hyprctl} dispatch dpms off";
  timeout = time: 300 + time;
in
{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "${screenOn}";
        ignore_dbus_inhibit = false;
        lock_cmd = "${isLocked} || ${hyprlock}";
      };
      listener = [
        {
          timeout = timeout 0;
          on-timeout = "${bright} -O && ${bright} -S 20";
          on-resume = "${bright} -I";
        }
        {
          timeout = timeout 60;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = timeout 300;
          on-timeout = "${screenOff}";
          on-resume = "${screenOn}";
        }
      ];
    };
  };
  # Systemd Unit provided is targeted to start before WAYLAND_DISPLAY
  # is defined. AJusting the precedence in order to the Unit works.
  # See: https://github.com/Vladimir-csp/uwsm/issues/40 .
  # TODO: Remove this line as soon as it gets fixed.
  systemd.user.services.hypridle.Unit.After = [ "graphical-session.target" ];
}
