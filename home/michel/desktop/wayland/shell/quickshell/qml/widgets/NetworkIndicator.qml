import QtQuick
import Quickshell.Io
import ".."

Widget {
    id: root

    signal openControlCenter

    readonly property var status: {
        try {
            return JSON.parse(collector.text || "{}");
        } catch (e) {
            return {};
        }
    }
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

    Process {
        id: proc
        command: [theme.networkStatusScript]
        stdout: StdioCollector {
            id: collector
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: proc.exec([theme.networkStatusScript])
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.openControlCenter()
    }
}
