{ pkgs, ... }:
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
in {
  environment.systemPackages = [ sway-vega ];
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        # Comment out if need some logs and verbose output
        # command = "sway-vega -V > ~/.sway.log 2>&1";
        command = "sway-vega";
        user = "michel";
      };
      default_session = initial_session;
    };
  };
}
