{ pkgs, ... }:
{
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = nvim-treesitter.withAllGrammars;
      type = "lua";
      config = # lua
        ''
          require'nvim-treesitter.configs'.setup {
            auto_install = false,
            highlight = {
              enable = true,
              additional_vim_regex_highlighting = false,
            },
          }
        '';
    }
    nvim-treesitter-textobjects
    playground
    SchemaStore-nvim
    vim-nix
    yuck-vim
    vimtex
  ];
}
