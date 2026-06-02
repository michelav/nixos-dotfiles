{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.userPrefs;
  quickshell = pkgs.quickshell;
  playerStatus = pkgs.writeShellScript "quickshell-player-status" ''
    status="$(${pkgs.playerctl}/bin/playerctl status 2>/dev/null || true)"
    title="$(${pkgs.playerctl}/bin/playerctl metadata --format '{{ artist }} - {{ title }}' 2>/dev/null || true)"

    if [ -z "$title" ]; then
      printf "󰝚 No media\n"
      exit 0
    fi

    case "$status" in
      Playing) icon="󰎆" ;;
      Paused) icon="󰏤" ;;
      *) icon="󰝚" ;;
    esac

    printf "%s %s\n" "$icon" "$(printf "%s" "$title" | ${pkgs.coreutils}/bin/cut -c 1-48)"
  '';
  systemStatus = pkgs.writeShellScript "quickshell-system-status" ''
    read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat
    idle_a=$((idle + iowait))
    total_a=$((user + nice + system + idle + iowait + irq + softirq + steal))

    ${pkgs.coreutils}/bin/sleep 0.2

    read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat
    idle_b=$((idle + iowait))
    total_b=$((user + nice + system + idle + iowait + irq + softirq + steal))

    total_delta=$((total_b - total_a))
    idle_delta=$((idle_b - idle_a))
    if [ "$total_delta" -gt 0 ]; then
      cpu=$((100 * (total_delta - idle_delta) / total_delta))
    else
      cpu=0
    fi

    mem="$(${pkgs.procps}/bin/free | ${pkgs.gawk}/bin/awk '/^Mem:/ { printf "%d", ($3 * 100) / $2 }')"
    load="$(${pkgs.coreutils}/bin/cut -d ' ' -f 1 /proc/loadavg)"
    temp_file="$(${pkgs.findutils}/bin/find /sys/class/thermal -name temp -print -quit 2>/dev/null || true)"

    if [ -n "$temp_file" ] && [ -r "$temp_file" ]; then
      temp_raw="$(${pkgs.coreutils}/bin/cat "$temp_file")"
      temp="$((temp_raw / 1000))"
      printf "󰍛 %s%%  󰘚 %s%%  󰔏 %s  󰔄 %sC\n" "$cpu" "$mem" "$load" "$temp"
    else
      printf "󰍛 %s%%  󰘚 %s%%  󰔏 %s\n" "$cpu" "$mem" "$load"
    fi
  '';
  volumeStatus = pkgs.writeShellScript "quickshell-volume-status" ''
    line="$(${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null || true)"
    volume="$(printf "%s" "$line" | ${pkgs.gawk}/bin/awk '{ printf "%d", $2 * 100 }')"
    if [ -z "$volume" ]; then
      volume=0
    fi

    if printf "%s" "$line" | ${pkgs.gnugrep}/bin/grep -q MUTED; then
      printf " %s%%\n" "$volume"
    elif [ "$volume" -ge 66 ]; then
      printf " %s%%\n" "$volume"
    elif [ "$volume" -ge 34 ]; then
      printf " %s%%\n" "$volume"
    else
      printf " %s%%\n" "$volume"
    fi
  '';
  networkStatus = pkgs.writeShellScript "quickshell-network-status" ''
    wifi="$(${pkgs.networkmanager}/bin/nmcli -t -f active,ssid dev wifi 2>/dev/null | ${pkgs.gnugrep}/bin/grep '^yes:' | ${pkgs.coreutils}/bin/cut -d : -f 2- | ${pkgs.coreutils}/bin/head -n 1)"
    if [ -n "$wifi" ]; then
      printf " %s\n" "$wifi"
    elif ${pkgs.networkmanager}/bin/nmcli -t -f state general 2>/dev/null | ${pkgs.gnugrep}/bin/grep -q connected; then
      printf "󰈀\n"
    else
      printf "\n"
    fi
  '';
  batteryStatus = pkgs.writeShellScript "quickshell-battery-status" ''
    battery="$(${pkgs.acpi}/bin/acpi -b 2>/dev/null | ${pkgs.coreutils}/bin/head -n 1 || true)"
    if [ -z "$battery" ]; then
      printf "\n"
      exit 0
    fi

    percent="$(printf "%s" "$battery" | ${pkgs.gnused}/bin/sed -n 's/.* \([0-9][0-9]*\)%.*/\1/p')"
    if printf "%s" "$battery" | ${pkgs.gnugrep}/bin/grep -q Discharging; then
      printf " %s%%\n" "$percent"
    else
      printf "󰢝 %s%%\n" "$percent"
    fi
  '';
in
lib.mkIf (cfg.desktopShell == "quickshell") {
  home.packages = [ quickshell ];

  xdg.configFile."quickshell/shell.qml".text = ''
    import QtQuick
    import QtQuick.Layouts
    import Quickshell
    import Quickshell.Hyprland
    import Quickshell.Io

    PanelWindow {
      id: panel

      readonly property string warning: "#${config.lib.stylix.colors.base0A}"
      readonly property string critical: "#${config.lib.stylix.colors.base08}"
      readonly property string moduleBg: "#${config.lib.stylix.colors.base03}"
      readonly property string moduleBgAlt: "#${config.lib.stylix.colors.base02}"
      readonly property string moduleFg: "#${config.lib.stylix.colors.base00}"
      readonly property string moduleFgAlt: "#${config.lib.stylix.colors.base06}"
      readonly property string workspaceFg: "#${config.lib.stylix.colors.base07}"
      readonly property string workspaceUrgent: "#${config.lib.stylix.colors.base09}"

      color: "transparent"
      implicitHeight: 32
      exclusiveZone: implicitHeight

      anchors {
        top: true
        left: true
        right: true
      }

      Rectangle {
        anchors.fill: parent
        color: "transparent"

        RowLayout {
          anchors.fill: parent
          anchors.leftMargin: 6
          anchors.rightMargin: 6
          anchors.topMargin: 3
          anchors.bottomMargin: 2
          spacing: 6

          RowLayout {
            Layout.alignment: Qt.AlignVCenter
            spacing: 3

            Repeater {
              model: Hyprland.workspaces

              Rectangle {
                required property var modelData

                Layout.preferredWidth: 28
                Layout.preferredHeight: 24
                radius: 3
                color: modelData.focused ? panel.moduleBgAlt : panel.moduleBg
                border.width: modelData.urgent ? 1 : 0
                border.color: panel.workspaceUrgent

                Text {
                  anchors.centerIn: parent
                  color: modelData.focused ? panel.workspaceFg : panel.moduleFg
                  font.family: "${config.stylix.fonts.sansSerif.name}"
                  font.pixelSize: 13
                  font.bold: modelData.active
                  text: modelData.name
                }

                MouseArea {
                  anchors.fill: parent
                  onClicked: modelData.activate()
                }
              }
            }
          }

          Module {
            Layout.maximumWidth: 360
            backgroundColor: panel.moduleBg
            textColor: panel.moduleFg
            text: playerCollector.text.trim() || "󰝚 No media"

            MouseArea {
              anchors.fill: parent
              acceptedButtons: Qt.LeftButton | Qt.RightButton
              onClicked: function(mouse) {
                if (mouse.button == Qt.RightButton) {
                  playerControl.exec(["${pkgs.playerctl}/bin/playerctl", "stop"]);
                } else {
                  playerControl.exec(["${pkgs.playerctl}/bin/playerctl", "play-pause"]);
                }
                playerPoll.restart();
              }
              onWheel: function(wheel) {
                playerControl.exec(["${pkgs.playerctl}/bin/playerctl", wheel.angleDelta.y > 0 ? "next" : "previous"]);
                playerPoll.restart();
              }
            }
          }

          Item {
            Layout.fillWidth: true
          }

          Module {
            Layout.alignment: Qt.AlignVCenter
            backgroundColor: panel.moduleBg
            textColor: panel.moduleFg
            text: "󰃰  " + Qt.formatDateTime(new Date(), "ddd, dd/MM/yyyy  HH:mm")

            Timer {
              interval: 1000
              running: true
              repeat: true
              onTriggered: parent.text = "󰃰  " + Qt.formatDateTime(new Date(), "ddd, dd/MM/yyyy  HH:mm")
            }
          }

          Module {
            backgroundColor: panel.moduleBg
            textColor: panel.moduleFg
            text: systemCollector.text.trim() || "󰍛 --%  󰘚 --%"
          }

          Module {
            backgroundColor: panel.moduleBg
            textColor: panel.moduleFg
            text: volumeCollector.text.trim() || " --%"

            MouseArea {
              anchors.fill: parent
              onClicked: Quickshell.execDetached(["${pkgs.pavucontrol}/bin/pavucontrol"])
            }
          }

          Module {
            backgroundColor: panel.moduleBg
            textColor: panel.moduleFg
            text: networkCollector.text.trim() || ""
          }

          Module {
            backgroundColor: panel.moduleBg
            textColor: panel.moduleFg
            text: "EN"
          }

          Module {
            backgroundColor: panel.moduleBg
            textColor: panel.moduleFg
            text: batteryCollector.text.trim() || ""
          }
        }
      }

      Process {
        id: playerProcess
        command: ["${playerStatus}"]
        stdout: StdioCollector {
          id: playerCollector
        }
      }

      Process {
        id: playerControl
      }

      Timer {
        id: playerPoll
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: playerProcess.exec(["${playerStatus}"])
      }

      Process {
        id: systemProcess
        command: ["${systemStatus}"]
        stdout: StdioCollector {
          id: systemCollector
        }
      }

      Timer {
        interval: 3000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: systemProcess.exec(["${systemStatus}"])
      }

      Process {
        id: volumeProcess
        command: ["${volumeStatus}"]
        stdout: StdioCollector {
          id: volumeCollector
        }
      }

      Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: volumeProcess.exec(["${volumeStatus}"])
      }

      Process {
        id: networkProcess
        command: ["${networkStatus}"]
        stdout: StdioCollector {
          id: networkCollector
        }
      }

      Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: networkProcess.exec(["${networkStatus}"])
      }

      Process {
        id: batteryProcess
        command: ["${batteryStatus}"]
        stdout: StdioCollector {
          id: batteryCollector
        }
      }

      Timer {
        interval: 30000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: batteryProcess.exec(["${batteryStatus}"])
      }

      component Module: Rectangle {
        property alias text: label.text
        property color backgroundColor: panel.moduleBg
        property color textColor: panel.moduleFg

        Layout.alignment: Qt.AlignVCenter
        Layout.preferredHeight: 24
        implicitWidth: Math.min(label.implicitWidth + 20, 380)
        radius: 3
        color: backgroundColor
        clip: true

        Text {
          id: label

          anchors.centerIn: parent
          width: Math.min(implicitWidth, parent.width - 14)
          elide: Text.ElideRight
          color: textColor
          font.family: "${config.stylix.fonts.sansSerif.name}"
          font.pixelSize: 13
          font.weight: Font.Medium
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
        }
      }
    }
  '';

  systemd.user.services.quickshell = {
    Unit = {
      Description = "QtQuick desktop shell";
      Documentation = "https://quickshell.org/docs/v0.3.0/";
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${quickshell}/bin/quickshell";
      Restart = "on-failure";
      Slice = "app-graphical.slice";
      Environment = "QS_NO_RELOAD_POPUP=1";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
