{ pkgs, inputs, ... }:
let keyring = pkgs.gnome.gnome-keyring;
in {
  imports = [ ./greetd.nix ];
  services = {
    # gnome.gnome-keyring.enable = true;
    dbus.packages = [ pkgs.gcr keyring ];
    blueman.enable = true;
  };
  security.pam.services.swaylock = { enableGnomeKeyring = true; };
  programs = {
    light.enable = true;
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };
  };
}
