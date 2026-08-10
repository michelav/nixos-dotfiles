import QtQuick

// Minimal draggable slider, normalized to a 0..1 value. Kept as a plain
// MouseArea + Rectangle pair instead of QtQuick.Controls.Slider so the
// popup panels don't depend on an unverified Controls style at runtime.
Item {
    id: root

    property real value: 0
    property color trackColor: "#303030"
    property color fillColor: "#8888ff"
    property bool enabled: true
    property bool hovered: mouse.containsMouse
    property bool pressed: mouse.pressed

    signal moved(real newValue)

    implicitHeight: 16
    focus: true
    opacity: enabled ? 1 : 0.45
    Keys.onLeftPressed: moved(Math.max(0, value - 0.05))
    Keys.onRightPressed: moved(Math.min(1, value + 0.05))

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: 4
        radius: 2
        color: root.trackColor
    }

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        x: Math.max(0, Math.min(parent.width - width, parent.width * root.value - width / 2))
        width: root.pressed ? 14 : 12
        height: width
        radius: width / 2
        color: root.fillColor
        Behavior on width { NumberAnimation { duration: 120 } }
    }

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width * Math.max(0, Math.min(1, root.value))
        height: 4
        radius: 2
        color: root.fillColor
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        enabled: root.enabled
        hoverEnabled: true

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
