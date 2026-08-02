{ lib, pkgs, ... }:
{
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
      noto-fonts-color-emoji
      nerd-fonts.jetbrains-mono
    ];
    fontconfig.defaultFonts = {
      serif = [ "Roboto Slab" ];
      sansSerif = [ "Inter" ];
      monospace = [ "JetBrainsMono Nerd Font" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  environment = {
    pathsToLink = lib.mkAfter [ "/share/fish" ];
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
