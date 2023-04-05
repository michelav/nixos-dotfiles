{ pkgs, ... }: {
  imports = [ ./greetd.nix ];
  services.gnome.gnome-keyring.enable = true;
  services.dbus.packages = [ pkgs.gcr ];
  services.blueman.enable = true;
  security.pam.services.swaylock = { };
  programs.light.enable = true;
  programs.hyprland.enable = true;
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
}
