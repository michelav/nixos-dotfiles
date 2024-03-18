{ config, pkgs, ... }:
let
  pinentry = if config.gtk.enable then {
    packages = [ pkgs.pinentry-gnome3 pkgs.gcr ];
    pkg = pkgs.pinentry-gnome3;
  } else {
    packages = [ pkgs.pinentry-curses ];
    pkg = pkgs.pinentry-curses;
  };
in {
  services.gpg-agent = {
    enable = true;
    enableFishIntegration = true;
    # enableSshSupport = true;
    pinentryPackage = pinentry.pkg;
  };

  programs.gpg = { enable = true; };

}
