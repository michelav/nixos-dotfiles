# Generates Theme.qml: the single Nix-interpolated QML file. It carries the
# stylix palette/fonts and nix-store script/binary paths so every other
# widget/panel QML file can stay static and be edited without touching Nix.
{
  config,
  scripts,
  bin,
}:
let
  colors = config.lib.stylix.colors;
  fonts = config.stylix.fonts;
in
''
  import QtQuick

  QtObject {
      // Palette
      readonly property color bg: "#${colors.base00}"
      readonly property color fg: "#${colors.base05}"
      readonly property color moduleBg: "#${colors.base03}"
      readonly property color moduleBgAlt: "#${colors.base02}"
      readonly property color moduleFg: "#${colors.base00}"
      readonly property color moduleFgAlt: "#${colors.base06}"
      readonly property color moduleFgAnm: "#${colors.base01}"
      readonly property color workspaceFg: "#${colors.base07}"
      readonly property color workspaceUrgent: "#${colors.base09}"
      readonly property color warning: "#${colors.base0A}"
      readonly property color critical: "#${colors.base08}"
      readonly property color accent: "#${colors.base0B}"
      readonly property color accentAlt: "#${colors.base0C}"

      // Layout
      readonly property int outerGap: ${toString config.wayland.windowManager.hyprland.settings.config.general.gaps_out}

      // Fonts
      readonly property string fontSans: "${fonts.sansSerif.name}"
      readonly property string fontMono: "${fonts.monospace.name}"

      // Scripts (nix-store paths, no native Quickshell service covers these)
      readonly property string systemStatusScript: "${scripts.systemStatus}"
      readonly property string networkStatusScript: "${scripts.networkStatus}"
      readonly property string wifiListScript: "${scripts.wifiList}"
      readonly property string wifiConnectScript: "${scripts.wifiConnect}"
      readonly property string brightnessStatusScript: "${scripts.brightnessStatus}"
      readonly property string calendarAgendaScript: "${scripts.calendarAgenda}"

      // Binaries
      readonly property string brightnessctlBin: "${bin.brightnessctl}"
      readonly property string wpctlBin: "${bin.wpctl}"
      readonly property string pavucontrolBin: "${bin.pavucontrol}"
  }
''
