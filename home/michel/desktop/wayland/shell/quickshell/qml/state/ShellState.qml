pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Hyprland

Singleton {
    property string openPanel: ""
    property string targetScreenName: ""
    property bool idleInhibited: false

    function screenName(screen) {
        return screen && screen.name ? screen.name : "";
    }

    function resolveTarget(screen) {
        const explicitName = screenName(screen);
        if (explicitName !== "")
            return explicitName;
        if (Hyprland.focusedMonitor && Hyprland.focusedMonitor.name)
            return Hyprland.focusedMonitor.name;
        return Quickshell.screens.length > 0 ? Quickshell.screens[0].name : "";
    }

    function togglePanel(panel, screen) {
        const target = resolveTarget(screen);
        if (openPanel === panel && targetScreenName === target) {
            closePanels();
            return;
        }
        targetScreenName = target;
        openPanel = panel;
    }

    function closePanels() {
        openPanel = "";
    }
}
