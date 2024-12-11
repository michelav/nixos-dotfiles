{ pkgs, inputs, ... }:
let
  keyring = pkgs.gnome-keyring;
in
{
  # TODO: Remove greetd.nix file after some time with this new config
  # imports = [ ./greetd.nix ];
  environment.systemPackages = [ inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default ];
  services = {
    dbus.packages = [
      pkgs.gcr
      keyring
    ];
    blueman.enable = true;
  };
  security.pam.services = {
    # TODO: Find a better pace to put this and remove swaylock and hyprlock from PAM
    login.enableGnomeKeyring = true;
    swaylock = {
      enableGnomeKeyring = true;
    };
    hyprlock = {
      enableGnomeKeyring = true;
    };
  };
  services.gnome.gnome-keyring.enable = true;
  programs = {
    light.enable = true;
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      withUWSM = true;
    };
  };
}
