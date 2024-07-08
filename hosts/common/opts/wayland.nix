{ pkgs, inputs, ... }:
let
  keyring = pkgs.gnome-keyring;
in
{
  imports = [ ./greetd.nix ];
  services = {
    dbus.packages = [
      pkgs.gcr
      keyring
    ];
    blueman.enable = true;
  };
  security.pam.services = {
    swaylock = {
      enableGnomeKeyring = true;
    };
    hyprlock = {
      enableGnomeKeyring = true;
    };
  };
  programs = {
    light.enable = true;
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };
  };
}
