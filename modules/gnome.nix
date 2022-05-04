{ pkgs, config, ... }:
{
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    layout = "br";
    xkbModel = "abnt2";
  };

  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
  services.power-profiles-daemon.enable = false;
  hardware.pulseaudio.enable = false;

  environment.gnome.excludePackages = with pkgs; [
    gnome.cheese
    gnome.gnome-terminal
    gnome-tour
    gnome.geary
  ];

  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
    gnomeExtensions.blur-my-shell
    gnomeExtensions.caffeine
    gnomeExtensions.sound-output-device-chooser
    gnomeExtensions.tiling-assistant
    gnomeExtensions.bluetooth-quick-connect
    gnomeExtensions.pop-shell
    gnome.gnome-tweaks
    libnotify
    notify-desktop
    pinentry_gnome
  ];

  services.gnome.core-developer-tools.enable = true;
  # USer Gnome Extensions from browser
  services.gnome.chrome-gnome-shell.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
