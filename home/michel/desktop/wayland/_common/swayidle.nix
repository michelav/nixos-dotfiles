{ pkgs, lib, ... }:
let
  swaylock = "${pkgs.swaylock-effects}/bin/swaylock";
  swaymsg = "${pkgs.sway}/bin/swaymsg";
  pgrep = "${pkgs.procps}/bin/pgrep";
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
  isLocked = "${pgrep} -x swaylock";
  swayScreenOff = ''${swaymsg} "output * dpms off"'';
  swayScreenOn = ''${swaymsg} "output * dpms on"'';
  hyprScreenOn = "${hyprctl} dispatch dpms on";
  hyprScreenOff = "${hyprctl} dispatch dpms off";
  toggleMic = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
  lockcmd = "${swaylock} -f -S";
  systemctl = "${pkgs.systemd}/bin/systemctl";
  restartServices = "${systemctl} --user gammastep.service";
  lockTime = 4 * 60;
  mkTimeout = time: action: resume: ''
    timeout ${toString (lockTime + time)} '${action}' ${
      lib.optionalString (resume != null) "resume '${resume}'"
    }
    timeout ${toString time} '${isLocked} && ${action}' ${
      lib.optionalString (resume != null) "resume '${isLocked} && ${resume}'"
    }
  '';
  mkEvent = event: action: ''
    ${event} '${action}'
  '';
in {
  home.packages = [ pkgs.swayidle ];
  xdg.configFile."swayidle/sway-config".text = ''
    timeout ${toString lockTime} '${lockcmd}'
  '' + (mkTimeout 10 "${toggleMic}" "${toggleMic}")
    + (mkTimeout 60 "${swayScreenOff}" "${swayScreenOn}")
    + (mkEvent "before-sleep" "${lockcmd}")
    + (mkEvent "after-resume" "${swayScreenOn} && ${restartServices}");

  xdg.configFile."swayidle/hypr-config".text = ''
    timeout ${toString lockTime} '${lockcmd}'
  '' + (mkTimeout 10 "${toggleMic}" "${toggleMic}")
    + (mkTimeout 60 "${hyprScreenOff}" "${hyprScreenOn}")
    + (mkEvent "before-sleep" "! ${isLocked} && ${lockcmd}")
    + (mkEvent "after-resume" "${hyprScreenOn} && ${restartServices}");
}
