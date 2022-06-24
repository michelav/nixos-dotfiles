{config, pkgs, lib, ... }:
{
  imports = [
    ./nix.nix
    ./pipewire.nix
    ./virtualisation.nix
  ];

  # Set your time zone.
  time.timeZone = "America/Fortaleza";

  # Select internationalisation properties.
  i18n.defaultLocale = "pt_BR.UTF-8";
  console = {
    font = "${pkgs.terminus_font}/share/consolefonts/ter-116n.psf.gz";
    packages = with pkgs; [
      terminus_font
    ];
    keyMap = "br-abnt2";
  };

  hardware.bluetooth.enable = true;

  programs = {
    fish.enable = true;
    dconf.enable = true;
  };

  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      corefonts
    ];
  };
 
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    unzip
    gnome.seahorse
  ];

  environment.pathsToLink = [ "/share/fish" ];

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
