{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.programs.ranger;
  ranger = pkgs.ranger;
in {
  options.programs.ranger = {
    enable = mkEnableOption "ranger";
    imagePreviewSupport = mkOption {
      type = types.bool;
      default = true;
    };
    waylandSupport = mkOption {
      type = types.bool;
      default = true;
      description = "If image preview should support wayland";
    };
    neoVimSupport = mkOption {
      type = types.bool;
      default = true;
    };
    improvedEncodingDetection = mkOption {
      type = types.bool;
      default = true;
    };
    rightToLeftTextSupport = mkOption {
      type = types.bool;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    home.packages = let
      finalRanger = ranger.overrideAttrs (_: p: {
        inherit (cfg)
          imagePreviewSupport neoVimSupport improvedEncodingDetection
          rightToLeftTextSupport;
        preConfigure = p.preConfigure + optionalString cfg.waylandSupport ''
          substituteInPlace ranger/config/rc.conf \
            --replace 'set preview_images_method w3m' \
                      'set preview_images_method kitty'
        '';
      });
    in [ finalRanger ];
  };
}
