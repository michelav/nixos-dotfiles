{ pkgs ? import <nixpkgs> { }, ... }:
let inherit (pkgs) python3 poetry;
in pkgs.mkShell {
  nativeBuildInputs = [ python3 (poetry.override { python = pkgs.python3; }) ];
}
