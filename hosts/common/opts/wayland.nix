{ pkgs, ... }:
let keyring = pkgs.gnome.gnome-keyring;
in {
  imports = [ ./greetd.nix ];
  services = {
    # gnome.gnome-keyring.enable = true;
    dbus.packages = [ pkgs.gcr keyring ];
    blueman.enable = true;
  };
  xdg.portal.extraPortals = [ keyring ];
  security.pam.services.swaylock = { enableGnomeKeyring = true; };
  programs = {
    seahorse.enable = true;
    light.enable = true;
    hyprland = { enable = true; };
  };
}
