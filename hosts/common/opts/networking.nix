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
    };
    wireless.iwd.enable = false;
  };

  systemd.services.NetworkManager-dundermifflin-compat = {
    description = "Disable PMF for the dundermifflin Wi-Fi profile";
    wantedBy = [ "multi-user.target" ];
    after = [ "NetworkManager.service" ];
    requires = [ "NetworkManager.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.networkmanager}/bin/nmcli connection modify dundermifflin 802-11-wireless-security.pmf 1";
    };
  };
}
