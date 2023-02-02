# Static networking configuration. It isn't used at moment.
{ pkgs, ... }: {
  networking = {
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
      dispatcherScripts = let nmcli = "${pkgs.networkmanager}/bin/nmcli";
      in [{
        source = pkgs.writeText "wlan_auto_toogle" ''
          lan_interface="enp8s0"
          if [ "$1" = $lan_interface ]; then
              case "$2" in
                  up)
                      ${nmcli} radio wifi off
                      echo "Turn wifi off"
                      ;;
                  down)
                      ${nmcli} radio wifi on
                      echo "Turn wifi on"
                      ;;
              esac
          elif [ "$(${nmcli} -g GENERAL.STATE device show $lan_interface)" = "20 (unavailable)" ]; then
              ${nmcli} radio wifi on
              echo "Turn wifi on"
          fi
        '';
        type = "basic";
      }];
    };
    wireless = {
      iwd = {
        enable = true;
        settings = { Network = { EnableIPv6 = true; }; };
      };
    };
  };
}
