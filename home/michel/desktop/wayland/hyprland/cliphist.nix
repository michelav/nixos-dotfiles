{ pkgs, ... }:
let
  cliphist = "${pkgs.cliphist}/bin/cliphist";
  wl-paste = "${pkgs.wl-clipboard}/bin/wl-paste";
in
{
  # Default services from home-manager don't work well
  # with UWSM.
  systemd.user.services.cliphist = {
    Unit = {
      Description = "Clipboard history manager for wayland";
      Documentation = "https://github.com/sentriz/cliphist";
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${wl-paste} --type text --watch ${cliphist} store";
      Restart = "on-failure";
      Slice = "app-graphical.slice";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
  systemd.user.services.cliphist-images = {
    Unit = {
      Description = "Clipboard history manager for wayland - Images";
      Documentation = "https://github.com/sentriz/cliphist";
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${wl-paste} --type image --watch ${cliphist} store";
      Restart = "on-failure";
      Slice = "app-graphical.slice";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
