{
  inputs,
  outputs,
  pkgs,
  config,
  ...
}:
{

  # The feats dictates what should be installed
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.nix-colors.homeManagerModules.default
    ./hm-impermanence-optin.nix
    ./cli
    ./cloud
    ./dev
    ./desktop/wayland
    ./gaming
    ./media
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  home.packages = with pkgs; [
    jq
    ripgrep
    fd
    tree
    htop
    btop
    gcc
    bc
    bottom
  ];

  home = {
    username = "michel";
    homeDirectory = "/home/michel";
    stateVersion = "23.05";
  };

  systemd.user.startServices = "sd-switch";

  userPrefs =
    let
      # colors-lib = inputs.nix-colors.lib.contrib { inherit pkgs; };
      # wp = colors-lib.nixWallpaperFromScheme {
      #   scheme = config.colorScheme;
      #   width = 1920;
      #   height = 1080;
      #   logoScale = 3.0;
      # };
      wp = "~/Pictures/wallpapers/dracula_nixos.png";
    in
    {
      enable = true;
      editor = "vim";
      browser = "firefox";
      terminal = "wezterm";
      # Check color schemes available at: https://tinted-theming.github.io/base16-gallery/
      # colorSchemeName = "one-light";
      colorSchemeName = "dracula";
      fonts = {
        monospace = {
          name = "JetBrainsMono Nerd Font";
          package = pkgs.nerd-fonts.jetbrains-mono;
        };
        regular = {
          name = "Inter";
          package = pkgs.inter;
        };
      };
      wallpaper = "${wp}";
    };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
