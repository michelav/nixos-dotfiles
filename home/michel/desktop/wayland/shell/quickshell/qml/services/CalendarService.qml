pragma Singleton

import Quickshell
import Quickshell.Io
import ".."

Singleton {
    id: root
    property var agenda: []
    RuntimeConfig { id: runtime }
    Process {
        id: process
        command: [runtime.calendarAgendaScript]
        stdout: StdioCollector {
            onStreamFinished: {
                try { root.agenda = JSON.parse(text || "[]"); }
                catch (error) { root.agenda = []; }
            }
        }
    }
    function refresh() { process.exec([runtime.calendarAgendaScript]); }
}
