{ config, pkgs, ... }:
let
  sway-vega = pkgs.writeTextFile {
    name = "sway-vega";
    destination = "/bin/sway-vega";
    executable = true;
    text = let
      intel = "0000:00:02.0";
      # nvidia = "0000:00:01.0";
    in ''
      export WLR_DRM_DEVICES=$(udevadm info -q property --value -n /dev/dri/by-path/pci-${intel}-card | grep /dev/dri/card)
      sway
    '';
  };
  inherit (config) gtk;
  regreet = "${pkgs.greetd.regreet}/bin/regreet";
in {
  environment.systemPackages =
    [ sway-vega pkgs.nordic pkgs.nordzy-cursor-theme pkgs.nordzy-icon-theme ];
  environment.etc."greetd/sway-config".text = ''
    exec "${regreet} -l debug; swaymsg exit"
    include /etc/sway/config.d/*
  '';
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command =
          "sway -V --unsupported-gpu --config /etc/greetd/sway-config > /persist/logs/regreet-sway.log 2>&1";
        user = "greeter";
      };
    };
  };
  programs.regreet = {
    enable = true;
    settings = {
      background = {
        path =
          "${pkgs.nordic}/share/themes/Nordic/extras/wallpapers/nordic-wall.jpg";
        fit = "Fill";
      };
      GTK = {
        application_prefer_dark_theme = true;
        cursor_theme_name = "Nordzy-cursors";
        font_name = "Roboto 12";
        icon_theme_name = "Nordzy";
        theme_name = "Nordic";
      };
      commands = {
        reboot = [ "systemctl" "reboot" ];
        poweroff = [ "systemctl" "poweroff" ];
      };
    };
  };
}
