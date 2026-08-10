import QtQuick
import ".."
import "../services"

Widget {
    id: root

    signal openSystemPanel

    readonly property var stats: SystemService.stats
    readonly property var cpu: stats.cpu

    text: "󰍛 " + (cpu === undefined ? "--" : cpu) + "%"
    backgroundColor: theme.moduleBg
    textColor: theme.moduleFg
    fontFamily: theme.fontSans

    Theme {
        id: theme
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.openSystemPanel()
    }
}
