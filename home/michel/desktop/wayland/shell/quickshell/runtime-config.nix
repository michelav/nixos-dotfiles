{ scripts, bin }:
''
  import QtQuick

  QtObject {
      readonly property string systemStatusScript: "${scripts.systemStatus}"
      readonly property string networkStatusScript: "${scripts.networkStatus}"
      readonly property string wifiListScript: "${scripts.wifiList}"
      readonly property string wifiConnectScript: "${scripts.wifiConnect}"
      readonly property string brightnessStatusScript: "${scripts.brightnessStatus}"
      readonly property string calendarAgendaScript: "${scripts.calendarAgenda}"
      readonly property string brightnessctlBin: "${bin.brightnessctl}"
      readonly property string hyprctlBin: "${bin.hyprctl}"
      readonly property string wpctlBin: "${bin.wpctl}"
      readonly property string pavucontrolBin: "${bin.pavucontrol}"
  }
''
