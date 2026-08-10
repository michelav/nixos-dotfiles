{
  pkgs,
  config,
  osConfig,
  lib,
  ...
}:
let
  cfg = config.userPrefs;
  quickshell = pkgs.quickshell;
  scripts = import ./scripts.nix { inherit pkgs; };
  bin = {
    brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
    hyprctl = "${osConfig.programs.hyprland.package}/bin/hyprctl";
    wpctl = "${pkgs.wireplumber}/bin/wpctl";
    pavucontrol = "${pkgs.pavucontrol}/bin/pavucontrol";
  };
  themeQml = import ./theme.nix { inherit config; };
  runtimeConfigQml = import ./runtime-config.nix { inherit scripts bin; };

  # Static QML files, copied as-is; only Theme.qml (generated above) carries
  # Nix-interpolated values, so everything below can be edited without
  # touching Nix.
  qmlRoot = ./qml;
  qmlFiles = map (file: lib.removePrefix "${toString qmlRoot}/" (toString file)) (
    lib.filesystem.listFilesRecursive qmlRoot
  );
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
      "quickshell/RuntimeConfig.qml".text = runtimeConfigQml;
    };

    systemd.user.services.quickshell = {
      Unit = {
        Description = "QtQuick desktop shell";
        Documentation = "https://quickshell.org/docs/v0.3.0/";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
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
