import QtQuick
import ".."

Rectangle {
    id: root
    property alias text: label.text
    implicitWidth: label.implicitWidth + theme.spaceMd
    implicitHeight: label.implicitHeight + theme.spaceSm
    radius: theme.radiusSm
    color: theme.surfaceElevated
    border.width: 1
    border.color: theme.outline
    Theme { id: theme }
    Text { id: label; anchors.centerIn: parent; color: theme.foreground; font.family: theme.fontSans; font.pixelSize: 11 }
}
