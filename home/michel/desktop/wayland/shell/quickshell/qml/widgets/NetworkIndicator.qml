import QtQuick
import ".."
import "../services"

Widget {
    id: root

    signal openControlCenter

    readonly property var status: NetworkService.status
    readonly property string icon: {
        if (status.type === "ethernet")
            return "󰈀";
        if (status.type !== "wifi")
            return "󰤭";
        const signal = status.signal || 0;
        if (signal >= 75)
            return "󰤨";
        if (signal >= 50)
            return "󰤥";
        if (signal >= 25)
            return "󰤢";
        return "󰤟";
    }

    text: icon + (status.type === "wifi" ? " " + (status.signal || 0) + "%" : "")
    backgroundColor: theme.moduleBg
    textColor: theme.moduleFg
    fontFamily: theme.fontSans

    Theme {
        id: theme
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.openControlCenter()
    }
}
