{
  config,
  lib,
  pkgs,
  ...
}:
let
  smartdNotify = pkgs.writeShellScript "smartd-systembus-notify" ''
    ${pkgs.dbus}/bin/dbus-send --system \
      / net.nuetzlich.SystemNotifications.Notify \
      "string:Problem detected with disk: $SMARTD_DEVICESTRING" \
      "string:Warning message from smartd: $SMARTD_MESSAGE"
  '';
  smartdConfig = pkgs.writeText "smartd.conf" ''
    DEVICESCAN -a -m <nomailer> -M exec ${smartdNotify}
  '';
in
{
  environment.systemPackages = with pkgs; [
    nvme-cli
    smartmontools
  ];

  boot.loader.systemd-boot.memtest86.enable = true;

  services = {
    smartd = {
      enable = true;
      autodetect = true;
      defaults.monitored = "-a";
      notifications = {
        mail.enable = false;
        systembus-notify.enable = true;
        wall.enable = false;
        x11.enable = false;
      };
    };

    btrfs.autoScrub = {
      enable = true;
      fileSystems = [ "/nix" ];
      interval = "monthly";
    };
  };

  systemd = {
    services = {
      # The upstream smartd module currently omits its notification command
      # when systembus-notify is the only enabled notification method.
      smartd.serviceConfig.ExecStart = lib.mkForce "${pkgs.smartmontools}/sbin/smartd --no-fork --configfile=${smartdConfig}";

      nix-store-verify = {
        description = "Verify all Nix store paths";
        onFailure = [ "nix-store-verify-notify.service" ];
        unitConfig.RequiresMountsFor = "/nix";
        serviceConfig = {
          Type = "oneshot";
          Nice = 19;
          CPUSchedulingPolicy = "idle";
          IOSchedulingClass = "idle";
          ExecStart = "${config.nix.package}/bin/nix store verify --all --no-trust";
        };
      };

      nix-store-verify-notify = {
        description = "Notify desktop users that Nix store verification failed";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = pkgs.writeShellScript "nix-store-verify-notify" ''
            ${pkgs.dbus}/bin/dbus-send --system \
              / net.nuetzlich.SystemNotifications.Notify \
              "string:Nix store verification failed on vega" \
              "string:Review the affected paths with: journalctl -u nix-store-verify.service"
          '';
        };
      };
    };

    timers.nix-store-verify = {
      description = "Monthly Nix store verification";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "*-*-15 04:00:00";
        Persistent = true;
        RandomizedDelaySec = "1h";
        Unit = "nix-store-verify.service";
      };
    };
  };
}
