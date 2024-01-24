{ inputs, config, pkgs, ... }:
let hyprw-contrib = inputs.hyprland-contrib.packages.${pkgs.system};
in {
  imports = [ inputs.hyprland.homeManagerModules.default ./wofi.nix ./eww ];
  home.packages = [ pkgs.swaybg pkgs.hyprpicker hyprw-contrib.grimblast ];
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    extraConfig = import ./config.nix { inherit config pkgs; };
  };
}
