{ config, pkgs, ... }: {

  home.packages = with pkgs;
    with nodePackages; [
      # language servers
      lua-language-server
      rnix-lsp
      nil
      nodejs
      dockerfile-language-server-nodejs
      vscode-langservers-extracted
      yaml-language-server
      gopls
      ccls
      tree-sitter
      pyright
      jsonlint
      prettier
      markdownlint-cli
      stylua
    ];
  imports = [ ./ui.nix ./syntaxes.nix ./workflow.nix ./lsp.nix ];
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs;
      with vimPlugins; [

        plenary-nvim
        {
          plugin = which-key-nvim;
          type = "lua";
          config = builtins.readFile ./cfg/mappings.lua;
        }
        vim-ledger
      ];
    extraConfig = let
      color =
        pkgs.writeText "color.vim" (import ./theme.nix config.colorscheme);
    in ''
      let g:loaded_perl_provider = 0
      source ${color}
      lua << EOF
        ${builtins.readFile ./cfg/extraConfig.lua}
      EOF
    '';
    extraPython3Packages = ps: with ps; [ greenlet ];
  };

}
