{ pkgs, ... }: {
  home.packages = [ pkgs.maestral pkgs.maestral-gui ];

  systemd.user.services.maestral-daemon = {
    Unit = {
      Description = "Maestral Dropbox Client";
      After = [ "lockOnAutoLogin.service" ];
      Requires = [ "lockOnAutoLogin.service" ];
    };
    Install = { WantedBy = [ "hyprland-session.target" ]; };
    Service = {
      Environment = [ "PYTHONOPTIMIZE=2" "LC_CTYPE=UTF-8" ];
      ExecStart = "${pkgs.maestral}/bin/maestral start -f -c maestral";
      ExecReload = "${pkgs.maestral}/bin/maestral stop -c maestral";
      WatchdogSec = "30";
    };
  };
}
