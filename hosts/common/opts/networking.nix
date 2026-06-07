# Static networking configuration. It isn't used at moment.
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # wifi
    iw
    wavemon
    ethtool
    pciutils
    usbutils

    # DNS / Route
    iproute2
    dnsutils
    mtr
    traceroute

    # Throughoput
    iperf

    # Traffic / Monitoring
    tcpdump
    nethogs
    iftop
    bmon
  ];
  networking = {
    networkmanager = {
      enable = true;
      wifi.backend = "wpa_supplicant";
      wifi.powersave = false;
      dispatcherScripts =
        let
          nmcli = "${pkgs.networkmanager}/bin/nmcli";
        in
        [
          {
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
          }
        ];
    };
    wireless.iwd.enable = false;
  };
}
