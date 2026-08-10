import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import ".."

RowLayout {
    id: root
    required property ShellScreen screen
    readonly property var monitor: Hyprland.monitorFor(screen)

    Layout.alignment: Qt.AlignVCenter
    spacing: 3

    Theme {
        id: theme
    }

    Repeater {
        model: Hyprland.workspaces.values.filter(workspace => workspace.monitor === root.monitor)

        Rectangle {
            id: ws
            required property var modelData
            readonly property bool special: modelData.name.indexOf("special") === 0

            Layout.preferredWidth: 28
            Layout.preferredHeight: theme.compactHeight
            radius: theme.radiusSm
            color: modelData.focused ? theme.moduleBgAlt : theme.moduleBg
            border.width: modelData.urgent ? 1 : 0
            border.color: theme.workspaceUrgent

            Text {
                anchors.centerIn: parent
                color: modelData.focused ? theme.workspaceFg : theme.moduleFg
                font.family: theme.fontSans
                font.pixelSize: 14
                font.bold: modelData.active
                text: ws.special ? "󰓎" : modelData.name
            }

            MouseArea {
                anchors.fill: parent
                onClicked: modelData.activate()
            }
        }
    }
}
