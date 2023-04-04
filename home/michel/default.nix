{ inputs, config, pkgs, lib, desktop, feats, ... }:
let inherit (lib) optional forEach;
in {

  # The feats dictates what should be installed
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.nix-colors.homeManagerModule
    ./hm-impermanence-optin.nix
  ] ++ forEach feats (f: ./${f})
    ++ optional (null != desktop) ./desktop/${desktop};

  home = { packages = with pkgs; [ jq ripgrep fd tree htop gcc bc ]; };

  systemd.user.startServices = "sd-switch";

  userPrefs = {
    enable = true;
    editor = "vim";
    browser = "firefox";
    terminal = "kitty";
    colorSchemeName = "nord";
    fonts = {
      monospace = {
        name = "JetBrainsMono Nerd Font";
        package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
      };
      regular = {
        name = "Inconsolata";
        package = pkgs.inconsolata;
      };
    };
    wallpaper = "~/Pictures/wallpapers/ign_astronaut.png";
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
