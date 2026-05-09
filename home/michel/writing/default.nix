{ pkgs, ... }:

let
  dictionaries = import ./dictionaries.nix { inherit pkgs; };
in
{
  home.packages = [
    pkgs.hunspell
    pkgs.enchant
  ]
  ++ dictionaries.packages;

  home.sessionVariables = {
    DICPATH = dictionaries.dictionaryPath;
  };
}
