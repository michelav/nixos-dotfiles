{ pkgs, ... }: {
  imports = [ ./pipewire.nix ./jellyfin.nix ./networking.nix ];

  programs = {
    fish.enable = true;
    dconf.enable = true;
    fuse.userAllowOther = true;
  };

  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [ corefonts ];
  };

  environment = {
    pathsToLink = [ "/share/fish" ];
    systemPackages = with pkgs; [ vim wget git unzip gnome.seahorse ];
  };

  # xdg-desktop-portal works by exposing a series of D-Bus interfaces
  # known as portals under a well-known name
  # (org.freedesktop.portal.Desktop) and object path
  # (/org/freedesktop/portal/desktop).
  # The portal interfaces include APIs for file access, opening URIs,
  # printing and others.
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };
}
