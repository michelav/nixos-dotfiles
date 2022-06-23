{config, pkgs, lib, ... }:
{
  imports = [
    ./nix.nix
    ./pipewire.nix
  ];
  networking.networkmanager.enable = true;

  # Set your time zone.
  time = {
    timeZone = "America/Fortaleza";
   # hardwareClockInLocalTime = true;
 };

  # nixpkgs.config.allowUnfree = true;

  networking.useDHCP = false;
  networking.interfaces.enp7s0.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

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

  services = {

    jellyfin.enable = true;
    jellyfin.openFirewall = true;

    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_BAT="powersave";
        CPU_SCALING_GOVERNOR_ON_AC="performance";

        USB_DENYLIST="046d:c534";

        # The following prevents the battery from charging fully to
        # preserve lifetime. Run `tlp fullcharge` to temporarily force
        # full charge.
        # https://linrunner.de/tlp/faq/battery.html#how-to-choose-good-battery-charge-thresholds
        # START_CHARGE_THRESH_BAT0=40;
        #  STOP_CHARGE_THRESH_BAT0=50;

        # 100 being the maximum, limit the speed of my CPU to reduce
        # heat and increase battery usage:
        # CPU_MAX_PERF_ON_AC=100;
        # CPU_MAX_PERF_ON_BAT=60;
      };
    };

    fstrim.enable = true;
    thermald.enable = true;

  };

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
    gnome.seahorse
  ];

  environment.pathsToLink = [ "/share/fish" ];

 programs.ssh.startAgent = true;
  programs.gnupg.agent = {
    enable = true;
    # enableSSHSupport = true;
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
    # gtk portal needed to make gtk apps happy
    # extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
