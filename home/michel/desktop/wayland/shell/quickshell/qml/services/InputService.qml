pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import ".."

Singleton {
    id: root

    property string keyboardName: ""
    property string layoutCode: ""

    function codeFor(layout) {
        const normalized = (layout || "").trim().toLowerCase();
        if (!normalized)
            return "";
        if (/\b(english|american|us)\b/.test(normalized))
            return "EN";
        if (/\b(portuguese|brazilian|br)\b/.test(normalized))
            return "PT";
        const word = normalized.split(/[^a-z]/).filter(part => part.length > 0)[0];
        return word ? word.slice(0, 2).toUpperCase() : "";
    }

    RuntimeConfig {
        id: runtime
    }

    Process {
        id: devicesProcess
        command: [runtime.hyprctlBin, "-j", "devices"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const devices = JSON.parse(text || "{}");
                    const keyboards = devices.keyboards || [];
                    const keyboard = keyboards.find(candidate => candidate.main === true);
                    root.keyboardName = keyboard ? keyboard.name : "";
                    root.layoutCode = keyboard ? root.codeFor(keyboard.active_keymap) : "";
                } catch (error) {
                    root.keyboardName = "";
                    root.layoutCode = "";
                }
            }
        }
    }

    Component.onCompleted: devicesProcess.exec([runtime.hyprctlBin, "-j", "devices"])

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (event.name !== "activelayout")
                return;
            const separator = event.data.indexOf(",");
            if (separator < 0 || event.data.slice(0, separator) !== root.keyboardName)
                return;
            root.layoutCode = root.codeFor(event.data.slice(separator + 1));
        }
    }
}
