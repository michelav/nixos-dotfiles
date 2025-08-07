{ pkgs, ... }:
{
  imports = [
    ./pipewire.nix
    ./networking.nix
    ./monitoring.nix
  ];

  programs = {
    fish.enable = true;
    dconf.enable = true;
    fuse.userAllowOther = true;
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      corefonts
      roboto-slab
      inter
      iosevka
      noto-fonts-emoji
    ];
    fontconfig.defaultFonts = {
      serif = [ "Roboto Slab" ];
      sansSerif = [ "Inter" ];
      monospace = [ "Iosevka" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  environment = {
    pathsToLink = [ "/share/fish" ];
    systemPackages = with pkgs; [
      vim
      wget
      git
      unzip
    ];
  };

  services.dbus = {
    enable = true;
    implementation = "broker";
  };
}
