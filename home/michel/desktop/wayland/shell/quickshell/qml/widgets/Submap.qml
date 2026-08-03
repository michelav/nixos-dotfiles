import QtQuick
import Quickshell.Hyprland
import ".."

Widget {
    id: root

    property string submap: ""

    visible: submap !== ""
    text: submap
    backgroundColor: theme.warning
    textColor: theme.moduleFgAnm
    fontFamily: theme.fontSans

    Theme {
        id: theme
    }

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (event.name === "submap") {
                root.submap = event.data;
            }
        }
    }
}
