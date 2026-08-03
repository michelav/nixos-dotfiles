import QtQuick
import Quickshell.Hyprland
import ".."

// Hyprland's `kb_layout = "us,br"` (hyprland/default.nix) doesn't map to a
// fixed "EN"/"PT" pair the way waybar's hardcoded format assumed, so this
// derives a short code from the live `activelayout` IPC event instead.
Widget {
    id: root

    property string rawLayout: ""
    readonly property string shortCode: {
        if (rawLayout === "")
            return "--";
        const word = rawLayout.trim().split(/[^A-Za-z]/)[0] || rawLayout;
        return word.slice(0, 2).toUpperCase();
    }

    text: shortCode
    backgroundColor: theme.moduleBg
    textColor: theme.moduleFg
    fontFamily: theme.fontSans

    Theme {
        id: theme
    }

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (event.name === "activelayout") {
                const parts = event.data.split(",");
                root.rawLayout = parts.length > 1 ? parts.slice(1).join(",") : event.data;
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: Hyprland.dispatch("switchxkblayout current next")
    }
}
