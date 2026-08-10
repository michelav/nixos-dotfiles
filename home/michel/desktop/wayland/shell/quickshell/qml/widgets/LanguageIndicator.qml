import QtQuick
import Quickshell.Hyprland
import ".."
import "../services"

Widget {
    id: root

    visible: InputService.layoutCode !== ""
    text: InputService.layoutCode
    backgroundColor: theme.moduleBg
    textColor: theme.moduleFg
    fontFamily: theme.fontSans

    Theme {
        id: theme
    }

    MouseArea {
        anchors.fill: parent
        onClicked: Hyprland.dispatch("switchxkblayout current next")
    }
}
