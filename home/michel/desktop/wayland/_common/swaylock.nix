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
      effect-blur = "10x2";
      fade-in = 0.5;
      grace = 2;

      font = fonts.monospace.name;
      font-size = 20;

      line-uses-inside = true;
      clock = true;
      disable-caps-lock-text = true;
      indicator-caps-lock = true;
      indicator-radius = 80;
      indicator-idle-visible = true;
      #      indicator-y-position = 1000;

      ring-color = "#${colors.base02}";
      inside-wrong-color = "#${colors.base08}";
      ring-wrong-color = "#${colors.base08}";
      key-hl-color = "#${colors.base0B}";
      bs-hl-color = "#${colors.base08}";
      ring-ver-color = "#${colors.base09}";
      inside-ver-color = "#${colors.base09}";
      inside-color = "#${colors.base01}";
      text-color = "#${colors.base07}";
      text-clear-color = "#${colors.base01}";
      text-ver-color = "#${colors.base01}";
      text-wrong-color = "#${colors.base01}";
      text-caps-lock-color = "#${colors.base07}";
      inside-clear-color = "#${colors.base0C}";
      ring-clear-color = "#${colors.base0C}";
      inside-caps-lock-color = "#${colors.base09}";
      ring-caps-lock-color = "#${colors.base02}";
      separator-color = "#${colors.base02}";
    };
  };
  systemd.user.services.lockOnAutoLogin = {
    Unit = { Description = "Lock the Screen after autologin"; };
    Install = { WantedBy = [ "hyprland-session.target" ]; };
    Service = {
      Type = "oneshot";
      RemainAfterExit = "true";
      Environment = [ "PYTHONOPTIMIZE=2" "LC_CTYPE=UTF-8" ];
      ExecStart = "${swaylock} -i ${wallpaper}";
    };
  };
}
