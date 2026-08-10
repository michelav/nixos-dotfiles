import QtQuick
import QtQuick.Layouts
import Quickshell
import ".."
import "../services"

PopupWindow {
    id: root

    property var hostWindow: null

    anchor.window: hostWindow
    anchor.rect.x: hostWindow ? Math.max(0, hostWindow.width / 2 - implicitWidth / 2) : 0
    anchor.rect.y: hostWindow ? hostWindow.height + 6 : 0

    implicitWidth: 260
    implicitHeight: column.implicitHeight + 28
    color: theme.moduleBgAlt

    Theme {
        id: theme
    }

    readonly property var stats: SystemService.stats

    component StatRow: RowLayout {
        Layout.fillWidth: true

        property alias icon: iconText.text
        property alias label: labelText.text
        property alias value: valueText.text

        Text {
            id: iconText
            color: theme.accentAlt
            font.family: theme.fontSans
        }
        Text {
            id: labelText
            color: theme.moduleFg
            font.family: theme.fontSans
        }
        Item {
            Layout.fillWidth: true
        }
        Text {
            id: valueText
            color: theme.moduleFg
            font.family: theme.fontMono
        }
    }

    ColumnLayout {
        id: column
        anchors.fill: parent
        anchors.margins: 14
        spacing: 10

        Text {
            text: "󰨇 System"
            color: theme.moduleFg
            font.family: theme.fontSans
            font.bold: true
            font.pixelSize: 15
        }

        StatRow {
            icon: "󰍛"
            label: "CPU"
            value: (root.stats.cpu === undefined ? "--" : root.stats.cpu) + "%"
        }
        StatRow {
            icon: "󰘚"
            label: "Memory"
            value: (root.stats.mem === undefined ? "--" : root.stats.mem) + "%"
        }
        StatRow {
            icon: "󰔏"
            label: "Load avg"
            value: root.stats.load === undefined ? "--" : root.stats.load
        }
        StatRow {
            icon: "󰔄"
            label: "Temperature"
            value: (root.stats.temp === undefined || root.stats.temp === null) ? "N/A" : root.stats.temp + "C"
        }
    }
}
