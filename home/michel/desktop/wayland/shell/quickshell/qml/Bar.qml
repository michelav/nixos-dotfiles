import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "widgets"
import "panels"

PanelWindow {
    id: bar

    property bool controlCenterOpen: false
    property bool calendarOpen: false
    property bool systemPanelOpen: false

    // Idle inhibition lives here (not in a bar widget) so it keeps working
    // regardless of whether Control Center is open; toggled from there.
    property bool idleInhibited: false

    IdleInhibitor {
        window: bar
        enabled: bar.idleInhibited
    }

    function closeAllPanels() {
        controlCenterOpen = false;
        calendarOpen = false;
        systemPanelOpen = false;
    }

    function openControlCenter() {
        const next = !controlCenterOpen;
        closeAllPanels();
        controlCenterOpen = next;
    }

    function openCalendar() {
        const next = !calendarOpen;
        closeAllPanels();
        calendarOpen = next;
    }

    function openSystemPanel() {
        const next = !systemPanelOpen;
        closeAllPanels();
        systemPanelOpen = next;
    }

    Theme {
        id: theme
    }

    color: "transparent"
    implicitHeight: 34
    exclusiveZone: implicitHeight

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
                onToggleCalendar: bar.openCalendar()
            }

            Item {
                Layout.fillWidth: true
            }

            SystemUsage {
                onOpenSystemPanel: bar.openSystemPanel()
            }
            QuickSettings {
                onOpenControlCenter: bar.openControlCenter()
            }
            LanguageIndicator {}
            Tray {}
        }
    }

    ControlCenter {
        hostWindow: bar
        visible: bar.controlCenterOpen
        idleInhibited: bar.idleInhibited
        onToggleIdle: bar.idleInhibited = !bar.idleInhibited
    }

    CalendarPanel {
        hostWindow: bar
        visible: bar.calendarOpen
    }

    SystemPanel {
        hostWindow: bar
        visible: bar.systemPanelOpen
    }
}
