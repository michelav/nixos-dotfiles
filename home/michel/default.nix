{
  inputs,
  outputs,
  pkgs,
  ...
}:
{

  # The feats dictates what should be installed
  imports = [
    inputs.stylix.homeModules.stylix
    ./hm-impermanence-optin.nix
    ./cli
    ./cloud
    ./dev
    ./desktop/wayland
    ./gaming
    ./media
    ./writing
  ]
  ++ (builtins.attrValues outputs.homeManagerModules);

  home.packages = with pkgs; [
    jq
    ripgrep
    fd
    tree
    htop
    btop-cuda
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

  userPrefs = {
    enable = true;
    editor = "vim";
    browser = "firefox";
    terminal = "wezterm";
    desktopShell = "quickshell";
    # Check color schemes available at: https://tinted-theming.github.io/base16-gallery/
    # colorSchemeName = "one-light";
    colorSchemeName = "nord";
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
