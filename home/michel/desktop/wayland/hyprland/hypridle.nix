{ pkgs, ... }:
let
  hyprlock = "${pkgs.hyprlock}/bin/hyprlock";
  pidof = "${pkgs.procps}/bin/pidof";
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
  bright = "${pkgs.light}/bin/light";
  isLocked = "${pidof} hyprlock";
  screenOn = "${hyprctl} dispatch dpms on";
  screenOff = "${hyprctl} dispatch dpms off";
  toggleMic = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
  systemctl = "${pkgs.systemd}/bin/systemctl";
  restartServices = "${systemctl} --user gammastep.service";
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
  systemd.user.services.lockOnAutoLogin = {
    Unit = { Description = "Lock the Screen after autologin"; };
    Install = { WantedBy = [ "hyprland-session.target" ]; };
    Service = {
      Type = "oneshot";
      RemainAfterExit = "true";
      Environment = [ "PYTHONOPTIMIZE=2" "LC_CTYPE=UTF-8" ];
      ExecStart = "${hyprlock} --immediate";
    };
  };
}
