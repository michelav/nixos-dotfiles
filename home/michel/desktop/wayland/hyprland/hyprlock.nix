{
  inputs,
  config,
  pkgs,
  ...
}:
let
  inherit (config.colorscheme) palette;
  inherit (config.userPrefs) fonts;
  inherit (inputs.nix-colors.lib.conversions) hexToRGBString;
  hex2RGB = hexToRGBString ", ";
  fortune = "${pkgs.fortune}/bin/fortune";
in
{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        grace = 2;
      };
      background = [
        {
          path = "~/Pictures/wallpapers/ign_astronaut.png";
          blur_passes = 2;
          blur_size = 4;
          vibrancy = 0.3;
        }
      ];
      input-field = [
        {
          size = "200, 40";
          outer_color = "rgb(${hex2RGB palette.base06})";
          inner_color = "rgb(${hex2RGB palette.base07})";
          font_color = "rgb(${hex2RGB palette.base00})";
          capslock_color = "rgb(${hex2RGB palette.base09})";
          fail_color = "rgb(${hex2RGB palette.base08})";
          halign = "center";
          valign = "center";
        }
      ];
      label = [
        {
          text = "cmd[update:600000] date +\"%a %d-%m-%Y\"";
          color = "rgb(${hex2RGB palette.base07})";
          font_size = 35;
          font_family = "${fonts.regular.name}";
          text_align = "left";
          halign = "right";
          valign = "top";
          position = "-45, -50";
        }
        {
          text = "$TIME";
          color = "rgb(${hex2RGB palette.base07})";
          font_size = 30;
          font_family = "${fonts.regular.name}";
          text_align = "left";
          halign = "right";
          valign = "top";
          position = "-45, -120";
        }
        {
          text = "cmd[update:600000] echo \"<i>$(${fortune} -s)</i>\"";
          color = "rgb(${hex2RGB palette.base07})";
          font_size = 20;
          font_family = "${fonts.monospace.name}";
          text_align = "left";
          halign = "left";
          valign = "bottom";
          position = "20, 20";
        }
      ];
    };
  };
}
