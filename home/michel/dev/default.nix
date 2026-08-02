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
  ];
}
