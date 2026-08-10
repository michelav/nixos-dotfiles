pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import ".."

Singleton {
    id: root
    property int percent: 0
    property int eventSerial: 0
    RuntimeConfig { id: runtime }
    Process {
        id: statusProcess
        command: [runtime.brightnessStatusScript]
        stdout: StdioCollector {
            onStreamFinished: root.percent = parseInt(text.trim() || "0", 10) || 0
        }
    }
    Timer { interval: 5000; running: true; repeat: true; triggeredOnStart: true; onTriggered: root.refresh() }
    function refresh() { statusProcess.exec([runtime.brightnessStatusScript]); }
    function setPercent(value) {
        percent = Math.max(1, Math.min(100, Math.round(value)));
        eventSerial++;
        Quickshell.execDetached([runtime.brightnessctlBin, "set", percent + "%"]);
    }
    function step(delta) { setPercent(percent + delta); }
}
