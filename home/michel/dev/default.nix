{ pkgs, ... }: {

  imports = [
    # ./vscode.nix 
    ./direnv.nix
    ./podman.nix
  ];

  home.packages = with pkgs; [ glow lazygit gnumake cmake ];
}
