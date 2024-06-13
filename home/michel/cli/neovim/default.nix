{ config, pkgs, ... }:
{

  home.packages = [
    pkgs.nodejs
    pkgs.tree-sitter
  ];
  imports = [
    ./ui.nix
    ./syntaxes.nix
    ./workflow.nix
    ./lsp.nix
  ];
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins =
      with pkgs;
      with vimPlugins;
      [
        plenary-nvim
        {
          plugin = which-key-nvim;
          type = "lua";
          config = builtins.readFile ./cfg/mappings.lua;
        }
        vim-ledger
      ];
    extraConfig =
      let
        color = pkgs.writeText "color.vim" (import ./theme.nix config.colorscheme);
      in
      ''
        let g:loaded_perl_provider = 0
        source ${color}
      '';
    extraLuaConfig = builtins.readFile ./cfg/extraConfig.lua;
    extraPython3Packages = ps: with ps; [ greenlet ];
    extraLuaPackages =
      ps: with ps; [
        magick
        # neorg dependencies
        lua-utils-nvim
        pathlib-nvim
        nvim-nio
      ];
    extraPackages = [ pkgs.imagemagick ];
  };

  home.persistence = {
    "/persist/home/michel" = {
      allowOther = true;
      files = [ ".local/state/nvim/trust" ];
    };
  };
}
