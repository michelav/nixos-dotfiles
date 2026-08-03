import QtQuick
import QtQuick.Layouts
import ".."

// Groups Volume/Network/Battery into one shared-background block (instead
// of separate visually-identical standalone pills) so it reads as a single
// "quick settings" cluster that opens Control Center, distinct from the
// standalone status pills (SystemUsage, Language, Tray) that don't.
// Brightness lives only in Control Center, not the bar.
Rectangle {
    id: root

    signal openControlCenter

    Layout.alignment: Qt.AlignVCenter
    Layout.preferredHeight: 24
    implicitWidth: row.implicitWidth + 16
    radius: 3
    color: theme.moduleBg

    Theme {
        id: theme
    }

    component Divider: Rectangle {
        Layout.fillHeight: true
        Layout.topMargin: 5
        Layout.bottomMargin: 5
        implicitWidth: 1
        color: theme.moduleFgAlt
        opacity: 0.3
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 8

        VolumeIndicator {
            backgroundColor: "transparent"
            onOpenControlCenter: root.openControlCenter()
        }
        Divider {}
        NetworkIndicator {
            backgroundColor: "transparent"
            onOpenControlCenter: root.openControlCenter()
        }
        Divider {}
        BatteryIndicator {
            backgroundColor: "transparent"
            onOpenControlCenter: root.openControlCenter()
        }
    }
}
