{ config, pkgs, ... }:
let
  inherit (config) colorscheme userPrefs;
  eww = pkgs.eww-wayland;
  xdgDir = config.xdg.configHome;
in {
  home.packages = [ eww pkgs.socat ];

  xdg.configFile = {
    "eww/eww.yuck".text = ''
      ;; includes
      (include "./widgets/workspaces.yuck")
      (include "./widgets/sys.yuck")
      (include "./widgets/net.yuck")
      (include "./widgets/bluetooth.yuck")
      ;; (include "./widgets/sound.yuck")
      ;; (include "./widgets/player.yuck")
      ;; (include "./widgets/bright.yuck")
      (include "./widgets/clock.yuck")

      (defwidget left []
        (box :orientation "h"
          :space-evenly false
          :halign "start"
          :class "right_modules"
          (workspaces)
        )
      )

      (defwidget right []
        (box :orientation "h"
          :space-evenly false
          :halign "end"
          :class "right_modules"
          (net)
          (bluetooth)
          (sys)
          (clock)
        )
      )

      (defwidget bar [] 
        (box :class "bar_class" :orientation "h"
          (left)
          (right))
      )

      (defwindow top-bar
        :monitor 0
        :geometry (geometry :x "0%"
                :y "9px"
                :width "98%"
                :height "30px"
                :anchor "top center")
        :stacking "fg"
        (bar))

      ;; (defwindow dashboard)
    '';

    "eww/_theme.scss".text = let
      inherit (colorscheme) palette;
      inherit (userPrefs) fonts;
    in ''
      // base colors from base16 config
      $base00: #${palette.base00};
      $base01: #${palette.base01};
      $base02: #${palette.base02};
      $base03: #${palette.base03};
      $base04: #${palette.base04};
      $base05: #${palette.base05};
      $base06: #${palette.base06};
      $base07: #${palette.base07};
      $base08: #${palette.base08};
      $base09: #${palette.base09};
      $base0A: #${palette.base0A};
      $base0B: #${palette.base0B};
      $base0C: #${palette.base0C};
      $base0D: #${palette.base0D};
      $base0E: #${palette.base0E};
      $base0F: #${palette.base0F};

      // Fonts
      $font: ${fonts.monospace.name};

      // background
      $bg: $base00;
      $fg: $base05;
      $brightfg: $base06;

      // status
      $urgent-st: $base0B;
      $ok-st: base0D;
      $warn-st: base0E;

      $date: $base08;
      $mem: $base0C;
      $bat: $base07;
      $brightbar1: $base0D;
      $brightbar2: $base0C;
      $brightbar3: $base0F;
      $volbar1: $base08;
      $volbar2: $base09;
      $volbar3: $base0A;
      $separ: $base02;
      $shadow1: $base01;
      $shadow2: $base03;
      $light1: $base04;
      $light2: $base03;
      $focus: $base08;
      $music: $base08;
    '';
    "eww/eww.scss".source = ./eww.scss;
    "eww/images".source = ./images;
    "eww/scripts".source = ./scripts;
    "eww/widgets".source = ./widgets;
    "eww/scss".source = ./scss;
  };
}
