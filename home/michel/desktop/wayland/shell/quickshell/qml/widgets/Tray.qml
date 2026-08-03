import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import Quickshell.Widgets

RowLayout {
    id: root
    Layout.alignment: Qt.AlignVCenter
    spacing: 6

    property var hostWindow: null

    Repeater {
        model: SystemTray.items

        IconImage {
            id: trayIcon
            required property var modelData

            implicitSize: 18
            source: modelData.icon

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: mouse => {
                    if (mouse.button === Qt.RightButton)
                        trayIcon.modelData.display(root.hostWindow, mouse.x, mouse.y);
                    else
                        trayIcon.modelData.activate();
                }
                onWheel: wheel => trayIcon.modelData.scroll(wheel.angleDelta.y, false)
            }
        }
    }
}
