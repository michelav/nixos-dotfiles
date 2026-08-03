import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import ".."

PopupWindow {
    id: root

    property var hostWindow: null
    property date today: new Date()

    anchor.window: hostWindow
    anchor.rect.x: hostWindow ? Math.max(0, hostWindow.width / 2 - implicitWidth / 2) : 0
    anchor.rect.y: hostWindow ? hostWindow.height + 6 : 0

    implicitWidth: 320
    implicitHeight: column.implicitHeight + 28
    color: theme.moduleBgAlt

    Theme {
        id: theme
    }

    property int viewYear: today.getFullYear()
    property int viewMonth: today.getMonth()

    function daysInMonth(year, month) {
        return new Date(year, month + 1, 0).getDate();
    }

    // Monday-first weekday index (0 = Monday .. 6 = Sunday).
    function firstWeekday(year, month) {
        const jsDay = new Date(year, month, 1).getDay();
        return (jsDay + 6) % 7;
    }

    function stepMonth(delta) {
        const d = new Date(root.viewYear, root.viewMonth + delta, 1);
        root.viewYear = d.getFullYear();
        root.viewMonth = d.getMonth();
    }

    function stepYear(delta) {
        root.viewYear += delta;
    }

    function goToday() {
        root.viewYear = root.today.getFullYear();
        root.viewMonth = root.today.getMonth();
    }

    property var gridCells: {
        const cells = [];
        const lead = firstWeekday(viewYear, viewMonth);
        for (let i = 0; i < lead; i++)
            cells.push(0);
        const total = daysInMonth(viewYear, viewMonth);
        for (let d = 1; d <= total; d++)
            cells.push(d);
        return cells;
    }

    readonly property bool viewingCurrentMonth: viewYear === today.getFullYear() && viewMonth === today.getMonth()

    onVisibleChanged: {
        if (visible) {
            root.today = new Date();
            root.goToday();
            agendaProc.exec([theme.calendarAgendaScript]);
        }
    }

    component NavButton: Rectangle {
        id: navBtn

        property alias label: navLabel.text
        property color fg: "#ffffff"
        property color hoverBg: "transparent"

        signal activated

        implicitWidth: 26
        implicitHeight: 26
        radius: 4
        color: navMouse.containsMouse ? hoverBg : "transparent"

        Text {
            id: navLabel
            anchors.centerIn: parent
            color: navBtn.fg
            font.bold: true
            font.pixelSize: 14
        }

        MouseArea {
            id: navMouse
            anchors.fill: parent
            hoverEnabled: true
            onClicked: navBtn.activated()
        }
    }

    Process {
        id: agendaProc
        command: [theme.calendarAgendaScript]
        stdout: StdioCollector {
            id: agendaCollector
            onStreamFinished: {
                try {
                    agendaList.model = JSON.parse(agendaCollector.text || "[]");
                } catch (e) {
                    agendaList.model = [];
                }
            }
        }
    }

    ColumnLayout {
        id: column
        anchors.fill: parent
        anchors.margins: 14
        spacing: 12

        RowLayout {
            Layout.fillWidth: true
            spacing: 2

            NavButton {
                label: "«"
                fg: theme.moduleFg
                hoverBg: theme.moduleBg
                onActivated: root.stepYear(-1)
            }
            NavButton {
                label: "‹"
                fg: theme.moduleFg
                hoverBg: theme.moduleBg
                onActivated: root.stepMonth(-1)
            }

            Text {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                text: Qt.formatDate(new Date(root.viewYear, root.viewMonth, 1), "MMMM yyyy")
                color: theme.moduleFg
                font.family: theme.fontSans
                font.bold: true
                font.pixelSize: 15

                MouseArea {
                    anchors.fill: parent
                    visible: !root.viewingCurrentMonth
                    onClicked: root.goToday()
                }
            }

            NavButton {
                label: "›"
                fg: theme.moduleFg
                hoverBg: theme.moduleBg
                onActivated: root.stepMonth(1)
            }
            NavButton {
                label: "»"
                fg: theme.moduleFg
                hoverBg: theme.moduleBg
                onActivated: root.stepYear(1)
            }
        }

        GridLayout {
            Layout.fillWidth: true
            columns: 7
            rowSpacing: 4
            columnSpacing: 4

            Repeater {
                model: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
                Text {
                    Layout.fillWidth: true
                    text: modelData
                    color: theme.accentAlt
                    font.family: theme.fontSans
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Repeater {
                model: root.gridCells
                Rectangle {
                    id: dayCell
                    required property int modelData
                    readonly property bool isToday: root.viewingCurrentMonth && modelData === root.today.getDate()

                    Layout.fillWidth: true
                    Layout.preferredHeight: 24
                    radius: 3
                    color: modelData !== 0 && dayCell.isToday ? theme.accentAlt : "transparent"

                    Text {
                        anchors.centerIn: parent
                        visible: dayCell.modelData !== 0
                        text: dayCell.modelData
                        color: dayCell.isToday ? theme.moduleFgAnm : theme.moduleFg
                        font.family: theme.fontSans
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: theme.moduleBg
        }

        Text {
            text: "󰃯 Upcoming"
            color: theme.moduleFg
            font.family: theme.fontSans
        }

        ListView {
            id: agendaList
            Layout.fillWidth: true
            Layout.preferredHeight: Math.min(200, count * 32)
            clip: true
            model: []

            delegate: RowLayout {
                id: agendaRow
                required property var modelData

                width: ListView.view ? ListView.view.width : 0

                Text {
                    text: agendaRow.modelData.date + " " + agendaRow.modelData.time
                    color: theme.moduleFgAlt
                    font.family: theme.fontMono
                    font.pixelSize: 11
                }
                Text {
                    Layout.fillWidth: true
                    text: agendaRow.modelData.title
                    color: theme.moduleFg
                    font.family: theme.fontSans
                    elide: Text.ElideRight
                }
            }
        }

        Text {
            visible: agendaList.count === 0
            text: "No upcoming events"
            color: theme.moduleFgAlt
            font.family: theme.fontSans
        }
    }
}
