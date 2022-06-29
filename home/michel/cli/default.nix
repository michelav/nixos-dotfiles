{ pkgs, ... }: {
  imports = [
    ./neovim
    # ./bat.nix
    ./fish.nix
    ./kitty.nix
    ./git.nix
    ./gpg.nix
    ./ssh.nix
  ];
  home.packages = with pkgs; [
    cachix # For managing my binary cache
    comma # Install and run programs by sticking a , before them
    distrobox # Nice escape hatch, integrates docker images with my environment

    bottom # System viewer
    ncdu # TUI disk usage
    exa # Better ls
    ripgrep # Better grep
    fd # Better find
    httpie # Better curl
    jq # JSON pretty printer and manipulator

    nvd nix-diff # Check derivation differences
    rnix-lsp # Nix LSP
    nixfmt # Nix formatter
    deadnix # Nix dead code locator
    statix # Nix linter
    haskellPackages.nix-derivation # Inspecting .drv's

    neofetch
  ];

  programs = {
    alacritty.enable = true;
    bat.enable = true;
    kitty.enable = true;
    nix-index.enable = true;
    fzf.enable = true;
    fzf.enableFishIntegration = true;
  };
}
