{ pkgs, ... }:
{
  services.netdata = {
    enable = true;
    config.global = {
      "memory mode" = "ram";
      "debug log" = "none";
      "access log" = "none";
      "error log" = "syslog";
    };
    # habilita o coletor de unidades systemd
    configDir."go.d/systemdunits.conf" = pkgs.writeText "systemdunits.conf" ''
      jobs:
        - name: local
          source: local   # monitora o próprio host
    '';

    configDir."python.d.conf" = pkgs.writeText "python.d.conf" ''
      nvidia_smi: yes
    ''; # (opcional) override para compilar Netdata com a UI Cloud,
    # necessária caso queira usar o plugin de systemd-journal
    package = pkgs.netdata.override { withCloudUi = true; };
  };
  networking.firewall.allowedTCPPorts = [ 19999 ];
  systemd.services.netdata.path = [ pkgs.linuxPackages.nvidia_x11 ];
}
