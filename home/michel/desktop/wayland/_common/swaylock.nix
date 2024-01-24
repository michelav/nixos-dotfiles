{ config, pkgs, ... }:

let
  inherit (config.colorscheme) colors;
  inherit (config.userPrefs) fonts wallpaper;
  swaylock = "${pkgs.swaylock-effects}/bin/swaylock";
in {
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      effect-blur = "5x2";
      fade-in = 0.5;
      grace = 2;
      ignore-empty-password = true;
      daemonize = true;

      # INFO: Comment out if you wanna debug swaylock
      debug = true;

      font = fonts.regular.name;
      # font-size = 20;

      line-uses-inside = true;
      clock = true;
      disable-caps-lock-text = true;
      indicator-caps-lock = true;
      indicator-radius = 150;
      indicator-thickness = 15;
      indicator-idle-visible = true;

      ring-color = "#${colors.base07}88";
      # inside-wrong-color = "#${colors.base08}";
      inside-wrong-color = "#${colors.base01}22";
      ring-wrong-color = "#${colors.base08}";
      key-hl-color = "#${colors.base0B}";
      bs-hl-color = "#${colors.base01}";
      ring-ver-color = "#${colors.base09}";
      # inside-ver-color = "#${colors.base09}";
      inside-ver-color = "#${colors.base01}22";
      inside-color = "#${colors.base01}22";
      text-color = "#${colors.base07}";
      text-clear-color = "#${colors.base0C}";
      text-ver-color = "#${colors.base0A}";
      text-wrong-color = "#${colors.base08}";
      text-caps-lock-color = "#${colors.base09}";
      inside-clear-color = "#${colors.base01}22";
      ring-clear-color = "#${colors.base0C}";
      inside-caps-lock-color = "#${colors.base01}22";
      ring-caps-lock-color = "#${colors.base09}";
      separator-color = "#${colors.base02}00";
    };
  };
  systemd.user.services.lockOnAutoLogin = {
    Unit = { Description = "Lock the Screen after autologin"; };
    Install = { WantedBy = [ "hyprland-session.target" ]; };
    Service = {
      Type = "oneshot";
      RemainAfterExit = "true";
      Environment = [ "PYTHONOPTIMIZE=2" "LC_CTYPE=UTF-8" ];
      ExecStart = "${swaylock} -i ${wallpaper} --grace 0 --fade-in 0";
    };
  };
}
