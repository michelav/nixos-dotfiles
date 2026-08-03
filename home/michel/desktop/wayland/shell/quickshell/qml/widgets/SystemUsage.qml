import QtQuick
import Quickshell.Io
import ".."

Widget {
    id: root

    signal openSystemPanel

    readonly property var stats: {
        try {
            return JSON.parse(collector.text || "{}");
        } catch (e) {
            return {};
        }
    }
    readonly property var cpu: stats.cpu

    text: "󰍛 " + (cpu === undefined ? "--" : cpu) + "%"
    backgroundColor: theme.moduleBg
    textColor: theme.moduleFg
    fontFamily: theme.fontSans

    Theme {
        id: theme
    }

    Process {
        id: proc
        command: [theme.systemStatusScript]
        stdout: StdioCollector {
            id: collector
        }
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: proc.exec([theme.systemStatusScript])
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.openSystemPanel()
    }
}
