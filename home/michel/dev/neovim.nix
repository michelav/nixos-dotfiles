{
  config,
  inputs,
  pkgs,
  ...
}:

let
  system = pkgs.stdenv.hostPlatform.system;

  writing = import ../writing/dictionaries.nix { inherit pkgs; };

  # Stylix supplies the active palette, so each Home Manager variant (dark base,
  # light specialisation) gets its own nvim.
  theme = config.stylix.targets.nixvim.exportedModule;

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

  vim-js = aliasVimPkgs "vim-js" (nixvim.js.extend theme);
  vim-python = aliasVimPkgs "vim-python" (nixvim.python.extend theme);
in
{
  stylix.targets.nixvim = {
    enable = true;
    plugin = "base16-nvim";
  };

  home.packages = [
    (nixvim.default.extend theme)
    vim-js
    vim-python
  ];

  home.persistence."/persist" = {
    directories = [
      ".local/state/nvim"
      ".local/share/nvim/site/spell"
    ];
  };
}
