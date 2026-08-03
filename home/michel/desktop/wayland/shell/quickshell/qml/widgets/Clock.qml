import QtQuick
import ".."

Widget {
    id: root

    signal toggleCalendar

    text: "󰃰  " + Qt.formatDateTime(new Date(), "ddd, dd/MM/yyyy  HH:mm")
    backgroundColor: theme.moduleBg
    textColor: theme.moduleFg
    fontFamily: theme.fontSans

    Theme {
        id: theme
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.text = "󰃰  " + Qt.formatDateTime(new Date(), "ddd, dd/MM/yyyy  HH:mm")
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.toggleCalendar()
    }
}
