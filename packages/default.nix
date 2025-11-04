{
  pkgs ? import <nixpkgs> { },
  ...
}:
{
  browseros = pkgs.callPackage ./browseros { };
}
