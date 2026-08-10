import QtQuick
import QtQuick.Layouts
import ".."

Rectangle {
    id: root
    property alias text: label.text
    property color backgroundColor: theme.surfaceElevated
    property color textColor: theme.foreground
    property string fontFamily: theme.fontSans
    property bool interactive: false
    signal activated

    Layout.alignment: Qt.AlignVCenter
    Layout.preferredHeight: theme.compactHeight
    implicitWidth: Math.min(label.implicitWidth + theme.spaceXl, 380)
    radius: theme.radiusSm
    color: mouse.pressed ? theme.surfaceHover : (mouse.containsMouse && interactive ? theme.surfaceContainer : backgroundColor)
    clip: true
    Behavior on color {
        ColorAnimation {
            duration: theme.durationFast
        }
    }
    Theme {
        id: theme
    }
    Text {
        id: label
        anchors.centerIn: parent
        width: Math.min(implicitWidth, parent.width - theme.spaceLg)
        elide: Text.ElideRight
        color: root.textColor
        font.family: root.fontFamily
        font.pixelSize: 14
        font.weight: Font.Medium
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
    MouseArea {
        id: mouse
        anchors.fill: parent
        enabled: root.interactive
        hoverEnabled: true
        onClicked: root.activated()
    }
}
