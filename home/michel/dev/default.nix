{ pkgs, ... }: {

  imports = [
    # ./vscode.nix 
    ./podman.nix
    ./direnv.nix
  ];

  home.packages = with pkgs; [ glow lazygit gnumake cmake ];
}
