import QtQuick
import Quickshell
import ".."

PopupWindow {
    id: root
    color: "transparent"
    property alias surfaceData: surface.data
    Theme { id: theme }
    Rectangle {
        id: surface
        anchors.fill: parent
        color: theme.surfaceContainer
        radius: theme.radiusLg
        border.width: 1
        border.color: theme.outline
    }
}
