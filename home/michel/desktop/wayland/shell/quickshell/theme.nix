# Generates Theme.qml: the single Nix-interpolated QML file. It carries the
# semantic tokens (userPrefs.theme.tokens), stylix palette/fonts and
# nix-store script/binary paths so every other widget/panel QML file can stay
# static and be edited without touching Nix.
{
  config,
}:
let
  colors = config.lib.stylix.colors;
  tokens = config.userPrefs.theme.tokens;
  fonts = config.stylix.fonts;
in
''
  import QtQuick

  QtObject {
      // Semantic palette
      readonly property color background: "#${tokens.background}"
      readonly property color surface: "#${tokens.surface}"
      readonly property color surfaceContainer: "#${tokens.surfaceContainer}"
      readonly property color surfaceElevated: "#${tokens.surfaceElevated}"
      readonly property color surfaceHover: "#${tokens.surfaceHover}"
      readonly property color foreground: "#${tokens.foreground}"
      readonly property color foregroundMuted: "#${tokens.foregroundMuted}"
      readonly property color outline: "#${tokens.outline}"
      readonly property color primary: "#${tokens.primary}"
      readonly property color primaryForeground: "#${tokens.primaryForeground}"
      readonly property color secondary: "#${tokens.secondary}"
      readonly property color success: "#${tokens.success}"
      readonly property color error: "#${tokens.error}"

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
      readonly property color warning: "#${tokens.warning}"
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
