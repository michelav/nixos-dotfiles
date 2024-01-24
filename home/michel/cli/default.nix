{ pkgs, ... }: {
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
  ];

  home.sessionVariables = { NIX_SHELL_PRESERVE_PROMPT = 1; };

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
    nix-diff # Check derivation differences
    rnix-lsp # Nix LSP
    nixfmt # Nix formatter
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
      config = {
        theme = "gruvbox-light"; # XXX: Change it if colorscheme is changed
      };
    };
    # ranger.enable = true;
  };
}
