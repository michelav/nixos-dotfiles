{ config, ... }:

let inherit (config.colorscheme) colors;
in {
  programs.swaylock = {
    settings = {
      effect-blur = "10x2";
      fade-in = 0.5;
      grace = 2;

      font = config.fonts.monospace.name;
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
}
