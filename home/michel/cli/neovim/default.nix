{ inputs, config, pkgs, ... }:
{
  home.sessionVariables.EDITOR = "nvim";

  home.packages = with pkgs; [
    sumneko-lua-language-server
    rnix-lsp
    nur.repos.ouzu.catppuccin.gtk
    nodejs
    tree-sitter
    nodePackages.dockerfile-language-server-nodejs
    nodePackages.pyright
    nodePackages.jsonlint
    nodePackages.prettier
    stylua
  ];

  programs.neovim = 
  let
    nvimExtraPlugins = pkgs.callPackage ./extraPlugins.nix { inherit pkgs; };
  in
   {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs; with vimPlugins; [
      vim-nix
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = builtins.readFile ../../configs/nvim/lua/plugins/configs/lsp/init.lua;
      }
      # Basic
      {
        plugin = telescope-nvim;
        type = "lua";
        config = builtins.readFile ../../configs/nvim/lua/plugins/configs/telescope.lua;
      }
      telescope-fzf-native-nvim
      plenary-nvim
      nvim-web-devicons
      {
        plugin = which-key-nvim;
        type = "lua";
        config = builtins.readFile ../../configs/nvim/lua/mappings.lua;
      }
      {
        plugin = indent-blankline-nvim;
        type = "lua";
        config = ''
         vim.opt.list = true
         vim.opt.listchars:append("eol:↴")

         require("indent_blankline").setup {
           show_end_of_line = true,
           show_current_context = true,
           show_current_context_start = true
         }
        '';
      }
      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = ''
          require('gitsigns').setup()
        '';
      }
      {
        plugin = comment-nvim;
        type = "lua";
        config = '' require('Comment').setup() '';
      }  
      {
        plugin = hop-nvim;
        type = "lua";
        config = ''
          require'hop'.setup()
          vim.api.nvim_set_keymap('n', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
          vim.api.nvim_set_keymap('n', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})
          vim.api.nvim_set_keymap('o', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, inclusive_jump = true })<cr>", {})
          vim.api.nvim_set_keymap('o', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, inclusive_jump = true })<cr>", {})
          vim.api.nvim_set_keymap("", 't', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
          vim.api.nvim_set_keymap("", 'T', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})
          vim.api.nvim_set_keymap('n', '<leader>e', "<cmd> lua require'hop'.hint_words({ hint_position = require'hop.hint'.HintPosition.END })<cr>", {})
          vim.api.nvim_set_keymap('v', '<leader>e', "<cmd> lua require'hop'.hint_words({ hint_position = require'hop.hint'.HintPosition.END })<cr>", {})
          vim.api.nvim_set_keymap('o', '<leader>e', "<cmd> lua require'hop'.hint_words({ hint_position = require'hop.hint'.HintPosition.END, inclusive_jump = true })<cr>", {})
        '';
      }
      {
        plugin = null-ls-nvim;
        type = "lua";
        config = ''
        local nls = require "null-ls"
        local b = nls.builtins
        nls.setup({
          sources = {
            b.diagnostics.chtex,
            b.formatting.prettier,
            b.diagnostics.markdownlint,
            b.formatting.markdownlint,
            b.formatting.jq,
            b.diagnostics.jsonlint,
            b.diagnostics.statix,
            b.code_actions.statix,
            b.diagnostics.deadnix,
            b.formatting.nixfmt,
            b.diagnostics.fish,
            b.formatting.fourmolu,
            b.formatting.stylua,
          }
        })
        '';
      }
      # Completions
      {
        plugin = nvim-cmp;
        type = "lua";
        config = builtins.readFile ../../configs/nvim/lua/plugins/configs/cmp.lua;
      }
      cmp-nvim-lsp
      cmp-nvim-lua
      cmp-treesitter
      cmp-path
      cmp-buffer
      cmp-vsnip
      luasnip
      cmp_luasnip
      cmp-nvim-lsp-document-symbol
      cmp-cmdline
      friendly-snippets

      # Status
      {
        plugin = feline-nvim;
        type = "lua";
        config = ''
        require("feline").setup({
	        components = require('catppuccin.core.integrations.feline'),
        })
        '';
      }
      # Themes
      nightfox-nvim
      nvimExtraPlugins.nvim-catppuccin
      nord-nvim
      { 
        plugin = nvim-treesitter.withPlugins (p : tree-sitter.allGrammars); 
        type = "lua";
        config = ''
          local vim = vim
          local opt = vim.opt
          require'nvim-treesitter.configs'.setup {
            ensure_installed = { "c", "lua", "rust", "hcl" },
            highlight = {
             enable = true,
            },
          }
          opt.foldmethod = "expr"
          opt.foldexpr = "nvim_treesitter#foldexpr()"
        '';
      }
      {
        plugin = nvim-tree-lua;
        type = "lua";
        config = '' require("nvim-tree").setup() '';
      }
    ];
    extraConfig = ''
    lua << EOF
      ${builtins.readFile ../../configs/nvim/lua/settings.lua}
    EOF
    '';
  };
}
