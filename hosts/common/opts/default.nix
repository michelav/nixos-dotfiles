{ pkgs, ... }:
let
  activate-hm = pkgs.writeTextFile {
    name = "activate-hm";
    destination = "/bin/activate-hm";
    executable = true;
    text = let hm = "${pkgs.home-manager}/bin/home-manager";
    in ''
      generation=$(${hm} generations | head -1 | awk -F'->' '{print $2}')
      "$generation/activate &> /dev/null"
    '';
  };
in {
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
    systemPackages = with pkgs; [
      vim
      wget
      git
      unzip
      gnome.seahorse
      activate-hm
    ];
    loginShellInit = ''
      # Activate home-manager environment, if not already
      [ -d "$HOME/.nix-profile" ] || activate-hm
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
