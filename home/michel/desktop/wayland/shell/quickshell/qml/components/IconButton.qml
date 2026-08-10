import QtQuick
import ".."

Rectangle {
    id: root
    property alias text: label.text
    property bool checked: false
    property bool enabled: true
    signal activated
    implicitWidth: theme.targetSize
    implicitHeight: theme.targetSize
    radius: theme.radiusPill
    opacity: enabled ? 1 : theme.disabledOpacity
    color: checked ? theme.primary : (mouse.pressed ? theme.surfaceHover : (mouse.containsMouse ? theme.surfaceContainer : "transparent"))
    Theme { id: theme }
    Behavior on color { ColorAnimation { duration: theme.durationFast } }
    Text {
        id: label
        anchors.centerIn: parent
        color: root.checked ? theme.primaryForeground : theme.foreground
        font.family: theme.fontSans
        font.pixelSize: 15
    }
    MouseArea {
        id: mouse
        anchors.fill: parent
        enabled: root.enabled
        hoverEnabled: true
        onClicked: root.activated()
    }
}
