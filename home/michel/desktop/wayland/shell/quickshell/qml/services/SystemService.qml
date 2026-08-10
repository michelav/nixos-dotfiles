pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import ".."

Singleton {
    id: root
    property var stats: ({})

    RuntimeConfig { id: runtime }
    Process {
        id: process
        command: [runtime.systemStatusScript]
        stdout: StdioCollector {
            onStreamFinished: {
                try { root.stats = JSON.parse(text || "{}"); }
                catch (error) { root.stats = {}; }
            }
        }
    }
    Timer {
        interval: 3000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: process.exec([runtime.systemStatusScript])
    }
}
