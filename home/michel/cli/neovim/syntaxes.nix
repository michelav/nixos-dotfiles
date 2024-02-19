{ pkgs, ... }: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      # plugin = nvim-treesitter.withAllGrammars;
      plugin = nvim-treesitter.withPlugins (_: nvim-treesitter.allGrammars);
      type = "lua";
      config = # lua
        ''
          local opt = vim.opt
          require'nvim-treesitter.configs'.setup {
            highlight = {
              enable = true,
              additional_vim_regex_highlighting = {'org'},
            },
            playground = {
              enable = true,
              keybindings = {
                toggle_query_editor = 'o',
                toggle_hl_groups = 'i',
                toggle_injected_languages = 't',
                toggle_anonymous_nodes = 'a',
                toggle_language_display = 'I',
                focus_language = 'f',
                unfocus_language = 'F',
                update = 'R',
                goto_node = '<cr>',
                show_help = '?',
              },
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
