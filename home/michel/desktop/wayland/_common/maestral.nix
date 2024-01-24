{ pkgs, ... }: {
  home.packages = [ pkgs.maestral pkgs.maestral-gui ];

  systemd.user.services.maestral-daemon = {
    Unit = {
      Description = "Maestral Dropbox Client";
      After = [ "lockOnAutoLogin.service" ];
    };
    Install = { WantedBy = [ "hyprland-session.target" ]; };
    Service = {
      Environment = [ "PYTHONOPTIMIZE=2" "LC_CTYPE=UTF-8" ];
      Type = "notify";
      NotifyAccess = "exec";
      ExecStart = "${pkgs.maestral}/bin/maestral start -f -c maestral";
      ExecStop = "${pkgs.maestral}/bin/maestral stop -c maestral";
      ExecStopPost = ''
        /usr/bin/env bash -c "if [ ''${SERVICE_RESULT} != success ]; then notify-send Maestral 'Daemon failed'; fi"
      '';
      WatchdogSec = "30";
    };
  };
}
