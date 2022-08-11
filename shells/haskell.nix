{ pkgs ? import <nixpkgs> { }, ... }:
pkgs.mkShell {
  name = "haskell";
  buildInputs = with pkgs; [
    ghc
    cabal-install
    zlib
    treefmt
    haskellPackages.fourmolu
    haskell-language-server
  ];
}
