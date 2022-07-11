{ pkgs ? import <nixpkgs> {}, ... }:
pkgs.mkShell {
  nativeBuildInputs = [
    pkgs.python39
    (pkgs.poetry.override { python = pkgs.python39; })
  ];
}
