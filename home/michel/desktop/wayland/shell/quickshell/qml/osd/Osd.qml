import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import ".."
import "../services"
import "../state"

PanelWindow {
    id: root
    required property ShellScreen modelScreen
    property string icon: ""
    property int percent: 0

    screen: root.modelScreen
    visible: hideTimer.running
    color: "transparent"
    implicitWidth: 220
    implicitHeight: 54
    exclusiveZone: 0
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell-osd"
    anchors { bottom: true }
    margins.bottom: 72

    function show(activeIcon, activePercent) {
        if (ShellState.resolveTarget(null) !== modelScreen.name)
            return;
        icon = activeIcon;
        percent = Math.max(0, Math.min(100, activePercent));
        hideTimer.restart();
    }

    Theme { id: theme }
    Timer { id: hideTimer; interval: 1400 }
    Connections {
        target: AudioService
        function onEventSerialChanged() {
            root.show(AudioService.sink?.audio?.muted ? "󰖁" : "󰕾", AudioService.volumePercent);
        }
    }
    Connections {
        target: BrightnessService
        function onEventSerialChanged() { root.show("󰃟", BrightnessService.percent); }
    }
    Rectangle {
        anchors.fill: parent
        color: theme.surfaceElevated
        radius: theme.radiusLg
        border.width: 1
        border.color: theme.outline
        RowLayout {
            anchors.fill: parent
            anchors.margins: theme.spaceMd
            spacing: theme.spaceMd
            Text { text: root.icon; color: theme.foreground; font.family: theme.fontSans; font.pixelSize: 20 }
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 6
                radius: 3
                color: theme.surfaceHover
                Rectangle { width: parent.width * root.percent / 100; height: parent.height; radius: 3; color: theme.primary }
            }
            Text { text: root.percent + "%"; color: theme.foreground; font.family: theme.fontMono }
        }
    }
}
