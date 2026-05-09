{ inputs, pkgs, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;

  writing = import ../writing/dictionaries.nix { inherit pkgs; };

  nixvim = inputs.nixvim-config.lib.mkNixvimPackages {
    inherit system;
    spellDictionaries = writing.dictionaries;
  };

  aliasVimPkgs =
    name: pkg:
    pkgs.runCommand "${name}" { } ''
      mkdir -p $out/bin
      ln -s ${pkg}/bin/nvim $out/bin/${name}
    '';

  vim-js = aliasVimPkgs "vim-js" nixvim.js;
  vim-python = aliasVimPkgs "vim-python" nixvim.python;
in
{
  home.packages = [
    nixvim.default
    vim-js
    vim-python
  ];
}
