import QtQuick
import Quickshell.Services.UPower
import ".."

Widget {
    id: root

    signal openControlCenter

    readonly property var device: UPower.displayDevice
    readonly property bool present: device !== null && device.ready && device.isPresent
    // UPower reports Percentage already as 0-100.
    readonly property int percent: present ? Math.round(device.percentage) : 0
    readonly property bool charging: present && (device.state === UPowerDeviceState.Charging || device.state === UPowerDeviceState.FullyCharged)
    readonly property bool isCritical: present && !charging && percent <= 15
    readonly property bool isWarning: present && !charging && percent <= 30
    readonly property string icon: {
        if (!present)
            return "󰂎";
        if (charging)
            return "󰢝";
        if (percent <= 15)
            return "󰁺";
        if (percent <= 40)
            return "󰁼";
        if (percent <= 65)
            return "󰁾";
        if (percent <= 90)
            return "󰂁";
        return "󰁹";
    }

    visible: present
    text: percent + "% " + icon
    backgroundColor: isCritical ? theme.critical : (isWarning ? theme.warning : theme.moduleBg)
    textColor: (isCritical || isWarning) ? theme.moduleFgAnm : theme.moduleFg
    fontFamily: theme.fontSans

    Theme {
        id: theme
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.openControlCenter()
    }
}
