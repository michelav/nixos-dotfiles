import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

RowLayout {
    id: root
    Layout.alignment: Qt.AlignVCenter
    spacing: 6

    Repeater {
        model: SystemTray.items

        IconImage {
            id: trayIcon
            required property var modelData

            implicitSize: 18
            source: modelData.icon

            QsMenuAnchor {
                id: menuAnchor
                menu: trayIcon.modelData.menu
                anchor.item: trayIcon
                anchor.edges: Edges.Bottom | Edges.Left
                anchor.gravity: Edges.Bottom | Edges.Right
                anchor.adjustment: PopupAdjustment.All
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                onClicked: mouse => {
                    if (mouse.button === Qt.MiddleButton) {
                        trayIcon.modelData.secondaryActivate();
                    } else if (mouse.button === Qt.RightButton) {
                        if (trayIcon.modelData.hasMenu)
                            menuAnchor.open();
                    } else if (trayIcon.modelData.onlyMenu && trayIcon.modelData.hasMenu) {
                        menuAnchor.open();
                    } else {
                        trayIcon.modelData.activate();
                    }
                }
                onWheel: wheel => trayIcon.modelData.scroll(wheel.angleDelta.y, false)
            }
        }
    }
}
