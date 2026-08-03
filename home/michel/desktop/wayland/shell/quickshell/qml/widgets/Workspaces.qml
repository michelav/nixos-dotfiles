import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import ".."

RowLayout {
    id: root
    Layout.alignment: Qt.AlignVCenter
    spacing: 3

    Theme {
        id: theme
    }

    Repeater {
        model: Hyprland.workspaces

        Rectangle {
            id: ws
            required property var modelData
            readonly property bool special: modelData.name.indexOf("special") === 0

            Layout.preferredWidth: 28
            Layout.preferredHeight: 24
            radius: 3
            color: modelData.focused ? theme.moduleBgAlt : theme.moduleBg
            border.width: modelData.urgent ? 1 : 0
            border.color: theme.workspaceUrgent

            Text {
                anchors.centerIn: parent
                color: modelData.focused ? theme.workspaceFg : theme.moduleFg
                font.family: theme.fontSans
                font.pixelSize: 13
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
