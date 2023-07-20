{ inputs, config, pkgs, ... }:
let
  hyprland-vega = pkgs.writeTextFile {
    name = "hyprland-vega";
    destination = "/bin/hyprland-vega";
    executable = true;
    text = let
      intel = "0000:00:02.0";
      # nvidia = "0000:00:01.0";
    in ''
      export WLR_DRM_DEVICES=$(udevadm info -q property --value -n /dev/dri/by-path/pci-${intel}-card | grep /dev/dri/card)
      Hyprland
    '';
  };
in {
  imports = [ inputs.hyprland.homeManagerModules.default ./wofi.nix ./eww ];
  home.packages = [ pkgs.swaybg pkgs.hyprpicker hyprland-vega ];
  programs = {
    fish.loginShellInit = ''
      if test (tty) = "/dev/tty1"
        exec hyprland-vega &> /dev/null
      end
    '';
    zsh.loginExtra = ''
      if [ "$(tty)" = "/dev/tty1" ]; then
        exec Hyprland &> /dev/null
      fi
    '';
    zsh.profileExtra = ''
      if [ "$(tty)" = "/dev/tty1" ]; then
        exec Hyprland &> /dev/null
      fi
    '';
  };
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    nvidiaPatches = true;
    extraConfig = import ./config.nix { inherit config; };
  };
}
