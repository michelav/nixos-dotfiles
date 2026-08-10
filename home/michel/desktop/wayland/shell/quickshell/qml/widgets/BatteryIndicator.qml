import QtQuick
import Quickshell.Services.UPower
import ".."

Widget {
    id: root

    signal openControlCenter

    readonly property var device: UPower.displayDevice
    readonly property bool present: device !== null && device.ready && device.isPresent
    readonly property int percent: present ? Math.round(device.percentage * 100) : 0
    readonly property bool charging: present && device.state === UPowerDeviceState.Charging
    readonly property bool pendingCharge: present && device.state === UPowerDeviceState.PendingCharge
    readonly property bool fullyCharged: present && device.state === UPowerDeviceState.FullyCharged
    readonly property bool externallyPowered: present && !UPower.onBattery
    readonly property bool chargingDisplay: externallyPowered && (charging || pendingCharge || fullyCharged)
    readonly property bool isCritical: present && UPower.onBattery && percent <= 15
    readonly property bool isWarning: present && UPower.onBattery && percent <= 30
    readonly property string icon: {
        if (!present)
            return "󰂎";
        if (chargingDisplay)
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
    backgroundColor: chargingDisplay ? theme.success : (isCritical ? theme.critical : (isWarning ? theme.warning : theme.moduleBg))
    textColor: (chargingDisplay || isCritical || isWarning) ? theme.moduleFgAnm : theme.moduleFg
    fontFamily: theme.fontSans

    Theme {
        id: theme
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.openControlCenter()
    }
}
