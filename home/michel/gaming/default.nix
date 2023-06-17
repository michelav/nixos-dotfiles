{ pkgs, ... }: {
  imports = [ ./steam.nix ./lutris.nix ];
  home.packages = [ pkgs.gamescope ];
}
