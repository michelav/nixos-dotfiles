{ pkgs, config, ... }:
{
  programs = {
    brave.enable = true;
    firefox = {
      enable = true;

      package = pkgs.firefox-wayland.override {
        cfg = {
          enableGnomeExtensions = true;
        };
      };
    };
  };
}
