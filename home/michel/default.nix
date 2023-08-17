{ inputs, outputs, pkgs, config, ... }: {

  # The feats dictates what should be installed
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.nix-colors.homeManagerModules.default
    ./hm-impermanence-optin.nix
    ./cli
    ./dev
    ./desktop/wayland
    ./finance
    ./gaming
    ./media
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

  userPrefs = let
    colors-lib = inputs.nix-colors.lib.contrib { inherit pkgs; };
    wp = colors-lib.nixWallpaperFromScheme {
      scheme = config.colorScheme;
      width = 1920;
      height = 1080;
      logoScale = 3.0;
    };
  in {
    enable = true;
    editor = "vim";
    browser = "firefox";
    terminal = "kitty";
    # Check color schemes available at: https://tinted-theming.github.io/base16-gallery/
    colorSchemeName = "one-light";
    # colorSchemeName = "gruvbox-light-soft";
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
    wallpaper = "${wp}";
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
