{ config, pkgs, ... }:
let
  pinentry = if config.gtk.enable then {
    packages = [ pkgs.pinentry-gnome pkgs.gcr ];
    name = "gnome3";
  } else {
    packages = [ pkgs.pinentry-curses ];
    name = "curses";
  };
in {
  services.gpg-agent = {
    enable = true;
    enableFishIntegration = true;
    # enableSshSupport = true;
    pinentryFlavor = pinentry.name;
  };

  programs.gpg = { enable = true; };

}
