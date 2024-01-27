{ pkgs, ... }: {
  imports = [ ./greetd.nix ];
  services = {
    # gnome.gnome-keyring.enable = true;
    # dbus.packages = [ pkgs.gcr ];
    blueman.enable = true;
  };
  security.pam.services.swaylock = { enableGnomeKeyring = true; };
  programs = {
    seahorse.enable = true;
    light.enable = true;
    hyprland = { enable = true; };
  };
}
