{ config, lib, pkgs, ... }:
let
swayConfig = pkgs.writeText "greetd-sway-config" ''
  # `-l` activates layer-shell mode. Notice that `swaymsg exit` will run after gtkgreet.
  exec "${pkgs.greetd.wlgreet}/bin/wlgreet -e sway; swaymsg exit"
  bindsym Mod4+shift+e exec swaynag \
    -t warning \
    -m 'What do you want to do?' \
    -b 'Poweroff' 'systemctl poweroff' \
    -b 'Reboot' 'systemctl reboot'
'';
in
{
 # services.greetd = {
 #   enable = true;
 #   settings = rec {
 #     initial_session = {
 #       command = "${pkgs.sway}/bin/sway";
 #       user = "michel";
 #     };
 #     default_session = initial_session;
 #     # {
 #     #   command = "${pkgs.sway}/bin/sway --unsupported-gpu --config ${swayConfig}";
 #     # };
 #   };
 # };

  # environment.etc."greetd/environments".text = ''
  #   sway
  #   fish
  # '';
#  services.gnome.gnome-keyring.enable = true;

  imports = [ ./greetd.nix ];

  services.dbus.packages = [ pkgs.gcr ];
  services.blueman.enable = true;
  security.pam.services.swaylock = {};
  programs.light.enable = true;
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
}
