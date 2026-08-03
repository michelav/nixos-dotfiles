{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.userPrefs;
  quickshell = pkgs.quickshell;
  scripts = import ./scripts.nix { inherit pkgs; };
  bin = {
    brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
    wpctl = "${pkgs.wireplumber}/bin/wpctl";
    pavucontrol = "${pkgs.pavucontrol}/bin/pavucontrol";
  };
  themeQml = import ./theme.nix { inherit config scripts bin; };

  # Static QML files, copied as-is; only Theme.qml (generated above) carries
  # Nix-interpolated values, so everything below can be edited without
  # touching Nix.
  qmlFiles = [
    "shell.qml"
    "Widget.qml"
    "Bar.qml"
    "Slider.qml"
    "widgets/Workspaces.qml"
    "widgets/Submap.qml"
    "widgets/Clock.qml"
    "widgets/MediaWidget.qml"
    "widgets/SystemUsage.qml"
    "widgets/QuickSettings.qml"
    "widgets/VolumeIndicator.qml"
    "widgets/NetworkIndicator.qml"
    "widgets/LanguageIndicator.qml"
    "widgets/BatteryIndicator.qml"
    "widgets/Tray.qml"
    "panels/ControlCenter.qml"
    "panels/CalendarPanel.qml"
    "panels/SystemPanel.qml"
  ];
  qmlConfigFiles = lib.listToAttrs (
    map (path: {
      name = "quickshell/${path}";
      value.source = ./qml/${path};
    }) qmlFiles
  );
in
{
  imports = [ ./calendar.nix ];

  config = lib.mkIf (cfg.desktopShell == "quickshell") {
    home.packages = [ quickshell ];

    xdg.configFile = qmlConfigFiles // {
      "quickshell/Theme.qml".text = themeQml;
    };

    systemd.user.services.quickshell = {
      Unit = {
        Description = "QtQuick desktop shell";
        Documentation = "https://quickshell.org/docs/v0.3.0/";
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${quickshell}/bin/quickshell";
        Restart = "on-failure";
        Slice = "app-graphical.slice";
        Environment = "QS_NO_RELOAD_POPUP=1";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
