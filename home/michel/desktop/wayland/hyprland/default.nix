{ inputs, config, pkgs, lib, ... }: {
  imports = [ inputs.hyprland.homeManagerModules.default ./wofi.nix ];
  home.packages = [ pkgs.swaybg pkgs.hyprpicker ];
  /* home.sessionVariables = {
       XDG_CURRENT_DESKTOP = "Hyprland";
       XDG_SESSION_DESKTOP = "Hyprland";
     };
  */
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    nvidiaPatches = true;
    extraConfig = import ./config.nix { inherit config; };
  };
}
