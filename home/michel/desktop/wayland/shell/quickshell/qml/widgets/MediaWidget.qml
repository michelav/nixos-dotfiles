import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import ".."

Widget {
    id: root

    readonly property var players: Mpris.players.values
    readonly property var player: {
        for (const p of players) {
            if (p.isPlaying) return p;
        }
        return players.length > 0 ? players[0] : null;
    }
    readonly property string icon: player === null ? "󰝚" : (player.isPlaying ? "󰎆" : "󰏤")
    readonly property string label: player === null ? "No media" : ((player.trackArtist ? player.trackArtist + " - " : "") + player.trackTitle).slice(0, 48)

    Layout.maximumWidth: 360
    text: icon + " " + label
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
            if (!root.player)
                return;
            if (mouse.button === Qt.RightButton)
                root.player.stop();
            else
                root.player.togglePlaying();
        }
        onWheel: wheel => {
            if (!root.player)
                return;
            if (wheel.angleDelta.y > 0)
                root.player.next();
            else
                root.player.previous();
        }
    }
}
