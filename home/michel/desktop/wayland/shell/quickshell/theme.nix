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
  import Quickshell
  import Quickshell.Io

  QtObject {
      id: root
      // Noctalia writes this palette whenever its active colors change. Keep
      // Stylix as the fallback for sessions that do not run Umbriel.
      property var noctaliaPalette: ({})
      FileView {
          id: noctaliaPaletteFile
          path: (Quickshell.env("XDG_CURRENT_DESKTOP") || "").toLowerCase() === "umbriel"
              ? "${config.xdg.configHome}/quickshell/noctalia-colors.json"
              : ""
          watchChanges: true
          onLoaded: {
              try { root.noctaliaPalette = JSON.parse(text()) }
              catch (error) { console.warn("Invalid Noctalia palette:", error) }
          }
          onFileChanged: reload()
      }
      function paletteColor(name, fallback) {
          return "#" + (noctaliaPalette[name] || fallback)
      }

      // Semantic palette
      readonly property color background: paletteColor("background", "${tokens.background}")
      readonly property color surface: paletteColor("surface", "${tokens.surface}")
      readonly property color surfaceContainer: paletteColor("surfaceContainer", "${tokens.surfaceContainer}")
      readonly property color surfaceElevated: paletteColor("surfaceElevated", "${tokens.surfaceElevated}")
      readonly property color surfaceHover: paletteColor("surfaceHover", "${tokens.surfaceHover}")
      readonly property color foreground: paletteColor("foreground", "${tokens.foreground}")
      readonly property color foregroundMuted: paletteColor("foregroundMuted", "${tokens.foregroundMuted}")
      readonly property color outline: paletteColor("outline", "${tokens.outline}")
      readonly property color primary: paletteColor("primary", "${tokens.primary}")
      readonly property color primaryForeground: paletteColor("primaryForeground", "${tokens.primaryForeground}")
      readonly property color secondary: paletteColor("secondary", "${tokens.secondary}")
      readonly property color success: paletteColor("success", "${tokens.success}")
      readonly property color error: paletteColor("error", "${tokens.error}")

      // Compatibility aliases while widgets migrate to semantic names.
      readonly property color bg: paletteColor("background", "${colors.base00}")
      readonly property color fg: paletteColor("foreground", "${colors.base05}")
      readonly property color moduleBg: paletteColor("surfaceContainer", "${colors.base02}")
      readonly property color moduleBgAlt: paletteColor("surfaceElevated", "${colors.base03}")
      readonly property color moduleFg: paletteColor("foreground", "${colors.base05}")
      readonly property color moduleFgAlt: paletteColor("foregroundMuted", "${colors.base04}")
      readonly property color moduleFgAnm: paletteColor("foreground", "${colors.base05}")
      readonly property color workspaceFg: paletteColor("foreground", "${colors.base05}")
      readonly property color workspaceUrgent: paletteColor("secondary", "${colors.base09}")
      readonly property color warning: paletteColor("warning", "${tokens.warning}")
      readonly property color critical: paletteColor("error", "${colors.base08}")
      readonly property color accent: paletteColor("primary", "${colors.base0B}")
      readonly property color accentAlt: paletteColor("secondary", "${colors.base0C}")

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
