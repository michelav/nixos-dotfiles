{ pkgs, config, ... }:
{
  imports = [
    ./neovim
    ./nnn.nix
    ./lf.nix
    ./fish.nix
    ./kitty.nix
    ./git.nix
    ./gpg.nix
    ./ssh.nix
    ./nix-index.nix
    ./pass.nix
    ./alacritty.nix
    ./eza.nix
    ./yazi.nix
  ];

  home.sessionVariables = {
    NIX_SHELL_PRESERVE_PROMPT = 1;
    LESS = "-R"; # permitir SGR/raw colors
    MANROFFOPT = "-c";
    MANPAGER = "most";
  };

  home.packages = with pkgs; [
    cachix # For managing my binary cache
    comma # Install and run programs by sticking a , before them
    distrobox # Nice escape hatch, integrates docker images with my environment

    bottom # System viewer
    ncdu # TUI disk usage
    ripgrep # Better grep
    fd # Better find
    httpie # Better curl
    jq # JSON pretty printer and manipulator

    nvd
    nh
    nix-diff # Check derivation differences
    nixfmt-rfc-style # Nix formatter
    deadnix # Nix dead code locator
    statix # Nix linter
    haskellPackages.nix-derivation # Inspecting .drv's

    neofetch
    most
  ];

  programs = {
    alacritty.enable = true;
    kitty.enable = true;
    fzf.enable = true;
    fzf.enableFishIntegration = true;
    bat = {
      enable = true;
      # config = { theme = "${config.userPrefs.colorSchemeName}"; };
    };
  };
}
