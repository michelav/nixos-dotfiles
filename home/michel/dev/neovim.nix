{ inputs, pkgs, ... }:
{
  home.packages =
    let
      system = pkgs.stdenv.hostPlatform.system;
      nixvim = inputs.nixvim-config.packages.${system};
      aliasVimPkgs =
        name: pkg:
        pkgs.runCommand "${name}" { } ''
          mkdir -p $out/bin
          ln -s ${pkg}/bin/nvim $out/bin/${name}
        '';
      vim-js = aliasVimPkgs "vim-js" nixvim.js;
      vim-python = aliasVimPkgs "vim-python" nixvim.python;
    in
    [
      # nixvim packages
      nixvim.default
      vim-js
      vim-python
    ];
}
