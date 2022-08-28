{ pkgs, lib, config, ... }: {
  services.swayidle = let
    swaylock = "${pkgs.swaylock-effects}/bin/swaylock";
    swaymsg = "${pkgs.sway}/bin/swaymsg";
    pgrep = "${pkgs.procps}/bin/pgrep";
    isLocked = "${pgrep} -x swaylock";
    screenOff = ''${swaymsg} "output * dpms off"'';
    screenOn = ''${swaymsg} "output * dpms on"'';
    lockcmd = "${swaylock} -f -S";
    systemctl = "${pkgs.systemd}/bin/systemctl";
  in {
    enable = true;

    timeouts = [
      {
        timeout = 240;
        command = "echo Idle. Locking device. && ${lockcmd}";
      }
      {
        # Try to turn screen off if locked by 1 min
        timeout = 300;
        command = "echo Turning Screen off && ${screenOff}";
        resumeCommand = "echo Turning Screen on && ${screenOn}";
      }
    ];
    events = [
      {
        event = "before-sleep";
        command = "${lockcmd}";
      }
      {
        event = "after-resume";
        command =
          "echo Resuming... && ${screenOn} && ${systemctl} --user restart gammastep.service";
      }
      {
        event = "lock";
        command = "${lockcmd}";
      }
    ];
  };
}
