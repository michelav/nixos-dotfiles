# Generates Theme.qml: the single Nix-interpolated QML file. It carries the
# stylix palette/fonts and nix-store script/binary paths so every other
# widget/panel QML file can stay static and be edited without touching Nix.
{
  config,
}:
let
  colors = config.lib.stylix.colors;
  fonts = config.stylix.fonts;
in
''
  import QtQuick

  QtObject {
      // Semantic palette
      readonly property color background: "#${colors.base00}"
      readonly property color surface: "#${colors.base01}"
      readonly property color surfaceContainer: "#${colors.base02}"
      readonly property color surfaceElevated: "#${colors.base03}"
      readonly property color surfaceHover: "#${colors.base04}"
      readonly property color foreground: "#${colors.base05}"
      readonly property color foregroundMuted: "#${colors.base04}"
      readonly property color outline: "#${colors.base03}"
      readonly property color primary: "#${colors.base0C}"
      readonly property color primaryForeground: "#${colors.base00}"
      readonly property color secondary: "#${colors.base0D}"
      readonly property color success: "#${colors.base0B}"
      readonly property color error: "#${colors.base08}"

      // Compatibility aliases while widgets migrate to semantic names.
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
      readonly property int spaceXs: 4
      readonly property int spaceSm: 8
      readonly property int spaceMd: 12
      readonly property int spaceLg: 16
      readonly property int spaceXl: 24
      readonly property int radiusSm: 6
      readonly property int radiusMd: 10
      readonly property int radiusLg: 14
      readonly property int radiusPill: 999
      readonly property int barHeight: 34
      readonly property int compactHeight: 26
      readonly property int controlHeight: 36
      readonly property int targetSize: 32
      readonly property real disabledOpacity: 0.45
      readonly property real mutedOpacity: 0.7
      readonly property int durationFast: 120
      readonly property int durationNormal: 180
      readonly property int durationSlow: 250

      // Fonts
      readonly property string fontSans: "${fonts.sansSerif.name}"
      readonly property string fontMono: "${fonts.monospace.name}"

  }
''
