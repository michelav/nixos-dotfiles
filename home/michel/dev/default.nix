{ pkgs, ... }:
{

  imports = [
    ./podman.nix
    ./direnv.nix
    ./neovim.nix
  ];

  home.packages = with pkgs; [
    glow
    lazygit
    gnumake
    cmake
    gcc
  ];

  home.persistence."/persist" = {
    directories = [
      ".local/share/devenv"
      ".local/state/lazygit"
    ];
  };
}
