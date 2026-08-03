import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import ".."

Widget {
    id: root

    signal openControlCenter

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property bool ready: sink !== null && sink.ready && sink.audio !== null
    readonly property int percent: ready ? Math.round(sink.audio.volume * 100) : 0
    readonly property bool muted: ready && sink.audio.muted
    readonly property string icon: {
        if (!ready || muted)
            return "󰖁";
        if (percent >= 66)
            return "󰕾";
        if (percent >= 34)
            return "󰖀";
        return "󰕿";
    }

    text: (ready ? percent + "% " : "--% ") + icon
    backgroundColor: theme.moduleBg
    textColor: theme.moduleFg
    fontFamily: theme.fontSans

    Theme {
        id: theme
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button === Qt.RightButton)
                Quickshell.execDetached([theme.pavucontrolBin]);
            else
                root.openControlCenter();
        }
        onWheel: wheel => {
            if (!root.ready)
                return;
            const delta = wheel.angleDelta.y > 0 ? 0.05 : -0.05;
            root.sink.audio.muted = false;
            root.sink.audio.volume = Math.max(0, Math.min(1.5, root.sink.audio.volume + delta));
        }
    }
}
