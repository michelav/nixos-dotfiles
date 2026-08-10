import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "widgets"
import "panels"
import "state"

PanelWindow {
    id: bar

    // Idle inhibition lives here (not in a bar widget) so it keeps working
    // regardless of whether Control Center is open; toggled from there.
    IdleInhibitor {
        window: bar
        enabled: ShellState.idleInhibited
    }

    Theme {
        id: theme
    }

    color: "transparent"
    implicitHeight: theme.barHeight
    exclusiveZone: implicitHeight
    exclusionMode: ExclusionMode.Normal
    aboveWindows: true
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.namespace: "quickshell-bar"

    anchors {
        top: true
        left: true
        right: true
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: theme.outerGap
            anchors.rightMargin: theme.outerGap
            anchors.topMargin: 3
            anchors.bottomMargin: 2
            spacing: 6

            Workspaces {
                screen: bar.screen
            }
            Submap {}
            MediaWidget {}

            Item {
                Layout.fillWidth: true
            }

            Clock {
                onToggleCalendar: ShellState.togglePanel("calendar", bar.screen)
            }

            Item {
                Layout.fillWidth: true
            }

            SystemUsage {
                onOpenSystemPanel: ShellState.togglePanel("system", bar.screen)
            }
            QuickSettings {
                onOpenControlCenter: ShellState.togglePanel("controlCenter", bar.screen)
            }
            LanguageIndicator {}
            Tray {}
        }
    }

    ControlCenter {
        hostWindow: bar
        visible: ShellState.openPanel === "controlCenter" && ShellState.targetScreenName === bar.screen.name
        idleInhibited: ShellState.idleInhibited
        onToggleIdle: ShellState.idleInhibited = !ShellState.idleInhibited
    }

    CalendarPanel {
        hostWindow: bar
        visible: ShellState.openPanel === "calendar" && ShellState.targetScreenName === bar.screen.name
    }

    SystemPanel {
        hostWindow: bar
        visible: ShellState.openPanel === "system" && ShellState.targetScreenName === bar.screen.name
    }
}
