{ pkgs, inputs, ... }:
let
  keyring = pkgs.gnome-keyring;
  system = pkgs.stdenv.hostPlatform.system;
in
{
  environment.systemPackages = [
    inputs.rose-pine-hyprcursor.packages.${system}.default
    pkgs.brightnessctl
  ];
  services = {
    dbus.packages = [
      pkgs.gcr
      keyring
    ];
    blueman.enable = true;
  };
  security.pam.services = {
    # TODO: Find a better place to put this and remove hyprlock from PAM
    login.enableGnomeKeyring = true;
    hyprlock = {
      enableGnomeKeyring = true;
    };
  };
  services.gnome.gnome-keyring.enable = true;
  programs = {
    hyprland =
      let
        system = pkgs.stdenv.hostPlatform.system;
        inherit (inputs.hyprland.packages.${system}) hyprland xdg-desktop-portal-hyprland;
      in
      {
        enable = true;
        package = hyprland;
        portalPackage = xdg-desktop-portal-hyprland;
        withUWSM = true;
      };
  };
}
