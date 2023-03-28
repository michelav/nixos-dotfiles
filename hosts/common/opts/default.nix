{ config, pkgs, lib, ... }: {
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
    loginShellInit = ''
      # Activate home-manager environment, if not already
      [ -d "$HOME/.nix-profile" ] || /nix/var/nix/profiles/per-user/$USER/home-manager/activate &> /dev/null
    '';
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
