{ config, pkgs, ... }: {
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

  programs.neovim = let
    nvimExtraPlugins = pkgs.callPackage ./extraPlugins.nix { inherit pkgs; };
  in {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs;
      with vimPlugins; [
        vim-nix
        {
          plugin = nvim-lspconfig;
          type = "lua";
          config = builtins.readFile ./cfg/lsp.lua;
        }
        # Basic
        {
          plugin = telescope-nvim;
          type = "lua";
          config = builtins.readFile ./cfg/telescope.lua;
        }
        telescope-fzf-native-nvim
        plenary-nvim
        nvim-web-devicons
        {
          plugin = which-key-nvim;
          type = "lua";
          config = builtins.readFile ./cfg/mappings.lua;
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
          config = "require('Comment').setup() ";
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
            vim.api.nvim_set_keymap('n', '<leader>h', "<cmd> lua require'hop'.hint_words({ hint_position = require'hop.hint'.HintPosition.END })<cr>", {})
            vim.api.nvim_set_keymap('v', '<leader>h', "<cmd> lua require'hop'.hint_words({ hint_position = require'hop.hint'.HintPosition.END })<cr>", {})
            vim.api.nvim_set_keymap('o', '<leader>h', "<cmd> lua require'hop'.hint_words({ hint_position = require'hop.hint'.HintPosition.END, inclusive_jump = true })<cr>", {})
          '';
        }
        {
          plugin = null-ls-nvim;
          type = "lua";
          config = ''
            local nls = require "null-ls"
            local f = nls.builtins.formatting
            local d = nls.builtins.diagnostics
            local ca = nls.builtins.code_actions
            nls.setup({
              sources = {
                f.prettier,
                f.jq,
                f.markdownlint,
                f.fourmolu,
                f.stylua,
                f.nixfmt,
                d.markdownlint,
                d.jsonlint,
                d.statix,
                d.deadnix,
                d.fish,
                ca.statix,
              }
            })
          '';
        }
        # Completions
        {
          plugin = nvim-cmp;
          type = "lua";
          config = builtins.readFile ./cfg/cmp.lua;
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

        {
          plugin = nvim-autopairs;
          type = "lua";
          config = ''
            local status_ok, npairs = pcall(require, "nvim-autopairs")
            if not status_ok then
              return
            end

            npairs.setup {
              check_ts = true, -- treesitter integration
              disable_filetype = { "TelescopePrompt" },
            }

            local cmp_autopairs = require "nvim-autopairs.completion.cmp"
            local cmp_status_ok, cmp = pcall(require, "cmp")
            if not cmp_status_ok then
              return
            end
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done {})
          '';
        }
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
          plugin = nvim-treesitter.withPlugins (_: tree-sitter.allGrammars);
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
          config = ''
            require("nvim-tree").setup()
            local opts = { noremap = true, silent = true }
            local keymap = vim.api.nvim_set_keymap
            keymap("n", "<leader>e", ":NvimTreeFindFileToggle<cr>", opts)
          '';
        }
        rust-tools-nvim
      ];
    extraConfig = ''
      lua << EOF
        ${builtins.readFile ./cfg/extraConfig.lua}
      EOF
    '';
  };
}
