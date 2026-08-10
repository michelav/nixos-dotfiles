import QtQuick
import ".."

Rectangle {
    id: root
    property bool checked: false
    property bool enabled: true
    signal toggled(bool checked)
    implicitWidth: 42
    implicitHeight: 24
    radius: height / 2
    color: checked ? theme.primary : theme.surfaceHover
    opacity: enabled ? 1 : theme.disabledOpacity
    Theme { id: theme }
    Behavior on color { ColorAnimation { duration: theme.durationFast } }
    Rectangle {
        width: 18; height: 18; radius: 9
        y: 3
        x: root.checked ? root.width - width - 3 : 3
        color: root.checked ? theme.primaryForeground : theme.foreground
        Behavior on x { NumberAnimation { duration: theme.durationFast } }
    }
    MouseArea {
        anchors.fill: parent
        enabled: root.enabled
        onClicked: root.toggled(!root.checked)
    }
}
