{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.swayidle;
in
{

  options.services.swayidle = {
    # enable = mkEnableOption "swwayidle";

    debug = mkEnableOption "debug";

    lockcmd = mkOption {
      type = types.str;
      default = "swaylock -f";
      description = "Lock cmd to be run";
    };
  };

  config = mkIf cfg.enable {
    services.swayidle = {
      # enable = true;
      timeouts = [
          {
            timeout = 300;
            command = ''${pkgs.light}/bin/light -O && ${pkgs.light}/bin/light -S 25'';
            resumeCommand = ''${pkgs.light}/bin/light -I'';
          }
          {
            timeout = 420;
            command = "${cfg.lockcmd}";
          }
          {
            timeout = 600;
            command = ''swaymsg "output * dpms off"'';
            resumeCommand = ''swaymsg "output * dpms on"'';
          }
          {
            timeout = 900;
            command = ''${pkgs.systemd}/bin/systemctl suspend'';
          }
        ];
        events = [
          {
            event = "before-sleep";
            command = "${cfg.lockcmd}";
          }
          {
            event = "after-resume";
            command = ''swaymsg "output * dpms on"'';
          }
          {
            event = "lock";
            command = "${cfg.lockcmd}";
          }
        ];
      extraArgs = (if cfg.debug then [ "-d" ] else []);
    };
  };
}