pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import ".."

Singleton {
    id: root
    property var status: ({})
    property var accessPoints: []

    RuntimeConfig { id: runtime }
    Process {
        id: statusProcess
        command: [runtime.networkStatusScript]
        stdout: StdioCollector {
            onStreamFinished: {
                try { root.status = JSON.parse(text || "{}"); }
                catch (error) { root.status = {}; }
            }
        }
    }
    Process {
        id: wifiProcess
        command: [runtime.wifiListScript]
        stdout: StdioCollector {
            onStreamFinished: {
                try { root.accessPoints = JSON.parse(text || "[]"); }
                catch (error) { root.accessPoints = []; }
            }
        }
    }
    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: statusProcess.exec([runtime.networkStatusScript])
    }
    function refreshWifi() { wifiProcess.exec([runtime.wifiListScript]); }
    function connect(ssid) { Quickshell.execDetached([runtime.wifiConnectScript, ssid]); }
}
