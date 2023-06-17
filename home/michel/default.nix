{ inputs, outputs, pkgs, ... }: {

  # The feats dictates what should be installed
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.nix-colors.homeManagerModules.default
    ./hm-impermanence-optin.nix
    ./cli
    ./dev
    ./desktop/wayland
    ./gaming
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  nixpkgs = {
    inherit (outputs) overlays;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home.packages = with pkgs; [ jq ripgrep fd tree htop gcc bc bottom ];

  home = {
    username = "michel";
    homeDirectory = "/home/michel";
    stateVersion = "23.05";
  };

  systemd.user.startServices = "sd-switch";

  userPrefs = {
    enable = true;
    editor = "vim";
    browser = "firefox";
    terminal = "kitty";
    colorSchemeName = "gruvbox-light-soft";
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
    wallpaper = "~/Pictures/wallpapers/gruvbox/gruvbox-light-blue.png";
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
