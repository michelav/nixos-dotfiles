import QtQuick
import QtQuick.Layouts

// Shared "pill" component used by every bar widget/indicator.
Rectangle {
    id: root

    property alias text: label.text
    property color backgroundColor: "#303030"
    property color textColor: "#eeeeee"
    property string fontFamily: "sans-serif"

    Layout.alignment: Qt.AlignVCenter
    Layout.preferredHeight: 26
    implicitWidth: Math.min(label.implicitWidth + 20, 380)
    radius: 3
    color: backgroundColor
    clip: true

    Text {
        id: label
        anchors.centerIn: parent
        width: Math.min(implicitWidth, parent.width - 14)
        elide: Text.ElideRight
        color: root.textColor
        font.family: root.fontFamily
        font.pixelSize: 14
        font.weight: Font.Medium
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
