import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Pipewire
import ".."
import "../services"

PopupWindow {
    id: root

    property var hostWindow: null
    property bool idleInhibited: false

    signal toggleIdle

    anchor.window: hostWindow
    anchor.rect.x: hostWindow ? Math.max(0, hostWindow.width - implicitWidth - 12) : 0
    anchor.rect.y: hostWindow ? hostWindow.height + 6 : 0

    implicitWidth: 340
    implicitHeight: column.implicitHeight + 24
    color: theme.moduleBgAlt

    Theme {
        id: theme
    }
    RuntimeConfig { id: runtime }

    readonly property var networkStatus: NetworkService.status

    onVisibleChanged: {
        if (visible) {
            NetworkService.refreshWifi();
            BrightnessService.refresh();
        }
    }

    Timer {
        interval: 15000
        running: root.visible
        repeat: true
        onTriggered: NetworkService.refreshWifi()
    }

    ColumnLayout {
        id: column
        anchors.fill: parent
        anchors.margins: 14
        spacing: 14

        // Volume
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4

            RowLayout {
                Layout.fillWidth: true
                Text {
                    text: "󰕾 Volume"
                    color: theme.moduleFg
                    font.family: theme.fontSans
                }
                Item {
                    Layout.fillWidth: true
                }
                Text {
                    text: "󰘮"
                    color: theme.moduleFg
                    font.family: theme.fontSans

                    MouseArea {
                        anchors.fill: parent
                        onClicked: Quickshell.execDetached([runtime.pavucontrolBin])
                    }
                }
                Text {
                    text: Pipewire.defaultAudioSink?.audio ? Math.round(Pipewire.defaultAudioSink.audio.volume * 100) + "%" : "--%"
                    color: theme.moduleFg
                    font.family: theme.fontSans
                }
                Text {
                    text: Pipewire.defaultAudioSink?.audio?.muted ? "󰖁" : "󰕾"
                    color: theme.moduleFg
                    font.family: theme.fontSans
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (Pipewire.defaultAudioSink?.audio)
                                Pipewire.defaultAudioSink.audio.muted = !Pipewire.defaultAudioSink.audio.muted;
                        }
                    }
                }
            }

            Slider {
                Layout.fillWidth: true
                value: Pipewire.defaultAudioSink?.audio ? Math.min(1, Pipewire.defaultAudioSink.audio.volume) : 0
                trackColor: theme.moduleBg
                fillColor: theme.accentAlt
                onMoved: newValue => {
                    if (Pipewire.defaultAudioSink?.audio) {
                        Pipewire.defaultAudioSink.audio.muted = false;
                        Pipewire.defaultAudioSink.audio.volume = newValue;
                    }
                }
            }
        }

        // Microphone
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4

            RowLayout {
                Layout.fillWidth: true
                Text {
                    text: "󰍬 Microphone"
                    color: theme.moduleFg
                    font.family: theme.fontSans
                }
                Item {
                    Layout.fillWidth: true
                }
                Text {
                    text: Pipewire.defaultAudioSource?.audio ? Math.round(Pipewire.defaultAudioSource.audio.volume * 100) + "%" : "--%"
                    color: theme.moduleFg
                    font.family: theme.fontSans
                }
                Text {
                    text: Pipewire.defaultAudioSource?.audio?.muted ? "󰍭" : "󰍬"
                    color: theme.moduleFg
                    font.family: theme.fontSans
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (Pipewire.defaultAudioSource?.audio)
                                Pipewire.defaultAudioSource.audio.muted = !Pipewire.defaultAudioSource.audio.muted;
                        }
                    }
                }
            }

            Slider {
                Layout.fillWidth: true
                value: Pipewire.defaultAudioSource?.audio ? Math.min(1, Pipewire.defaultAudioSource.audio.volume) : 0
                trackColor: theme.moduleBg
                fillColor: theme.accentAlt
                onMoved: newValue => {
                    if (Pipewire.defaultAudioSource?.audio) {
                        Pipewire.defaultAudioSource.audio.muted = false;
                        Pipewire.defaultAudioSource.audio.volume = newValue;
                    }
                }
            }
        }

        // Brightness
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4

            RowLayout {
                Layout.fillWidth: true
                Text {
                    text: "󰃟 Brightness"
                    color: theme.moduleFg
                    font.family: theme.fontSans
                }
                Item {
                    Layout.fillWidth: true
                }
                Text {
                    text: BrightnessService.percent + "%"
                    color: theme.moduleFg
                    font.family: theme.fontSans
                }
            }

            Slider {
                Layout.fillWidth: true
                value: BrightnessService.percent / 100
                trackColor: theme.moduleBg
                fillColor: theme.accentAlt
                onMoved: newValue => {
                    BrightnessService.setPercent(newValue * 100);
                }
            }
        }

        // Idle inhibitor + language
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 32
                radius: 4
                color: root.idleInhibited ? theme.accentAlt : theme.moduleBg

                Text {
                    anchors.centerIn: parent
                    text: root.idleInhibited ? "󰍹 Idle disabled" : "󰷛 Idle enabled"
                    color: theme.moduleFg
                    font.family: theme.fontSans
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.toggleIdle()
                }
            }

            Rectangle {
                Layout.preferredWidth: 90
                Layout.preferredHeight: 32
                radius: 4
                color: theme.moduleBg

                Text {
                    anchors.centerIn: parent
                    text: "󰌌 Layout"
                    color: theme.moduleFg
                    font.family: theme.fontSans
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: Hyprland.dispatch("switchxkblayout current next")
                }
            }
        }

        // Wi-Fi
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 4

            Text {
                text: "󰖩 Wi-Fi"
                color: theme.moduleFg
                font.family: theme.fontSans
            }

            Text {
                text: {
                    if (root.networkStatus.type === "wifi")
                        return "Connected to " + root.networkStatus.ssid;
                    if (root.networkStatus.type === "ethernet")
                        return "Wired connection";
                    return "Not connected";
                }
                color: theme.moduleFgAlt
                font.family: theme.fontSans
                font.pixelSize: 11
            }

            ListView {
                id: wifiListView
                Layout.fillWidth: true
                Layout.preferredHeight: Math.min(160, count * 32)
                clip: true
                model: NetworkService.accessPoints

                delegate: Rectangle {
                    id: wifiRow
                    required property var modelData

                    width: ListView.view ? ListView.view.width : 0
                    height: 32
                    radius: 4
                    color: modelData.active ? theme.moduleBgAlt : "transparent"

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        anchors.rightMargin: 8

                        Text {
                            text: (modelData.secure ? "󰌾 " : "󰌿 ") + modelData.ssid
                            color: theme.moduleFg
                            font.family: theme.fontSans
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                        }
                        Text {
                            text: modelData.signal + "%"
                            color: theme.moduleFgAlt
                            font.family: theme.fontSans
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: NetworkService.connect(modelData.ssid)
                    }
                }
            }
        }
    }
}
