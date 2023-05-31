{ inputs, config, pkgs, ... }: {
  imports = [ inputs.hyprland.homeManagerModules.default ./wofi.nix ./eww ];
  home.packages = [ pkgs.swaybg pkgs.hyprpicker ];
  /* home.sessionVariables = {
       XDG_CURRENT_DESKTOP = "Hyprland";
       XDG_SESSION_DESKTOP = "Hyprland";
     };
  */
  #   programs = {
  #     fish.loginShellInit = ''
  #       if test (tty) = "/dev/tty1"
  #         exec Hyprland &> /dev/null
  #       end
  #     '';
  #     zsh.loginExtra = ''
  #       if [ "$(tty)" = "/dev/tty1" ]; then
  #         exec Hyprland &> /dev/null
  #       fi
  #     '';
  #     zsh.profileExtra = ''
  #       if [ "$(tty)" = "/dev/tty1" ]; then
  #         exec Hyprland &> /dev/null
  #       fi
  #     '';
  #   };
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    nvidiaPatches = true;
    extraConfig = import ./config.nix { inherit config; };
  };
}
