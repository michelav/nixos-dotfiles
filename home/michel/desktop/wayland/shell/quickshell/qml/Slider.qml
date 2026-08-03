import QtQuick

// Minimal draggable slider, normalized to a 0..1 value. Kept as a plain
// MouseArea + Rectangle pair instead of QtQuick.Controls.Slider so the
// popup panels don't depend on an unverified Controls style at runtime.
Item {
    id: root

    property real value: 0
    property color trackColor: "#303030"
    property color fillColor: "#8888ff"

    signal moved(real newValue)

    implicitHeight: 16

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: 4
        radius: 2
        color: root.trackColor
    }

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width * Math.max(0, Math.min(1, root.value))
        height: 4
        radius: 2
        color: root.fillColor
    }

    MouseArea {
        anchors.fill: parent

        function update(x) {
            root.moved(Math.max(0, Math.min(1, x / width)));
        }

        onPressed: mouse => update(mouse.x)
        onPositionChanged: mouse => {
            if (pressed)
                update(mouse.x);
        }
    }
}
