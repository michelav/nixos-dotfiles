{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:

let
  system = pkgs.stdenv.hostPlatform.system;

  writing = import ../writing/dictionaries.nix { inherit pkgs; };

  # Stylix remains the base palette in Hyprland. Umbriel loads the current
  # Noctalia-generated Base16 file after that palette has initialized.
  theme = [
    config.stylix.targets.nixvim.exportedModule
    {
      extraConfigLua = lib.mkAfter ''
        if (vim.env.XDG_CURRENT_DESKTOP or ""):lower() == "umbriel" then
          local noctalia = vim.fn.stdpath("config") .. "/noctalia.lua"
          if vim.fn.filereadable(noctalia) == 1 then
            dofile(noctalia)
          end
        end
      '';
    }
  ];

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
