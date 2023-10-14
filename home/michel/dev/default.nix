{ pkgs, ... }: {

  imports = [
    # ./vscode.nix 
    ./direnv.nix
  ];

  home.packages = with pkgs; [ glow lazygit gnumake cmake ];
}
