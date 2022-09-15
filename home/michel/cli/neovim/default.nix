{ config, pkgs, ... }: {
  home.sessionVariables.EDITOR = "nvim";

  home.packages = with pkgs;
    with nodePackages; [
      sumneko-lua-language-server
      rnix-lsp
      nur.repos.ouzu.catppuccin.gtk
      nodejs
      tree-sitter
      dockerfile-language-server-nodejs
      pyright
      jsonlint
      prettier
      vscode-langservers-extracted
      markdownlint-cli
      stylua
    ];

  programs.neovim = let
    nvimExtraPlugins = pkgs.callPackage ./extraPlugins.nix { inherit pkgs; };
  in {
    enable = true;
    viAlias = true;
    vimAlias = true;
    package = pkgs.neovim;
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
          config = ''
            require('Comment').setup()
          '';
        }
        # {
        #   plugin = hop-nvim;
        #   type = "lua";
        #   config = ''
        #     require'hop'.setup()
        #     vim.api.nvim_set_keymap('n', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
        #     vim.api.nvim_set_keymap('n', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})
        #     vim.api.nvim_set_keymap('o', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, inclusive_jump = true })<cr>", {})
        #     vim.api.nvim_set_keymap('o', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, inclusive_jump = true })<cr>", {})
        #     vim.api.nvim_set_keymap("", 't', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
        #     vim.api.nvim_set_keymap("", 'T', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})
        #     vim.api.nvim_set_keymap('n', '<leader>h', "<cmd> lua require'hop'.hint_words({ hint_position = require'hop.hint'.HintPosition.END })<cr>", {})
        #     vim.api.nvim_set_keymap('v', '<leader>h', "<cmd> lua require'hop'.hint_words({ hint_position = require'hop.hint'.HintPosition.END })<cr>", {})
        #     vim.api.nvim_set_keymap('o', '<leader>h', "<cmd> lua require'hop'.hint_words({ hint_position = require'hop.hint'.HintPosition.END, inclusive_jump = true })<cr>", {})
        #   '';
        # }
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
        {
          plugin = trouble-nvim;
          type = "lua";
          config = ''
            require("trouble").setup {}
            local opts = { noremap = true, silent = true }
            local keymap = vim.api.nvim_set_keymap
            keymap("n", "<leader>xx", "<cmd>TroubleToggle<cr>", opts)
            keymap("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", opts)
            keymap("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", opts)
            keymap("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", opts)
            keymap("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", opts)
            keymap("n", "<leader>xr", "<cmd>TroubleToggle lsp_references<cr>", opts)
          '';
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
        {
          plugin = nvimExtraPlugins.nightfox-main;
          type = "lua";
          config = ''
            require("nightfox").setup({
              palettes = { nordfox = { bg1 = "#2e3441"}, },
            })
            vim.cmd("colorscheme nordfox")
          '';
        }
        nvimExtraPlugins.nvim-catppuccin
        nord-nvim
        nvimExtraPlugins.onenord
        {
          plugin = nvim-treesitter.withPlugins (p: [
            p.tree-sitter-bash
            p.tree-sitter-c
            p.tree-sitter-bibtex
            p.tree-sitter-cmake
            p.tree-sitter-commonlisp
            p.tree-sitter-cpp
            p.tree-sitter-css
            p.tree-sitter-dockerfile
            p.tree-sitter-elisp
            p.tree-sitter-elm
            p.tree-sitter-fish
            p.tree-sitter-go
            p.tree-sitter-haskell
            p.tree-sitter-hcl
            p.tree-sitter-html
            p.tree-sitter-http
            p.tree-sitter-java
            p.tree-sitter-javascript
            p.tree-sitter-json
            p.tree-sitter-json5
            p.tree-sitter-latex
            p.tree-sitter-llvm
            p.tree-sitter-lua
            p.tree-sitter-make
            p.tree-sitter-markdown
            p.tree-sitter-markdown-inline
            p.tree-sitter-nix
            p.tree-sitter-norg
            p.tree-sitter-org-nvim
            p.tree-sitter-perl
            p.tree-sitter-python
            p.tree-sitter-query
            p.tree-sitter-r
            p.tree-sitter-regex
            p.tree-sitter-rst
            p.tree-sitter-ruby
            p.tree-sitter-rust
            p.tree-sitter-scala
            p.tree-sitter-scheme
            p.tree-sitter-scss
            p.tree-sitter-sql
            p.tree-sitter-toml
            p.tree-sitter-typescript
            p.tree-sitter-vim
            p.tree-sitter-yaml
          ]);
          type = "lua";
          config = ''
            local opt = vim.opt
            require'nvim-treesitter.configs'.setup {
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
        {
          plugin = toggleterm-nvim;
          type = "lua";
          config = ''
            toggleterm = require("toggleterm")
            toggleterm.setup({
            	size = 20,
            	open_mapping = [[<c-\>]],
            	hide_numbers = true,
            	shade_filetypes = {},
            	shade_terminals = true,
            	shading_factor = 2,
            	start_in_insert = true,
            	insert_mappings = true,
            	persist_size = true,
            	-- direction = "float",
            	close_on_exit = true,
            	shell = vim.o.shell,
            	float_opts = {
            		border = "curved",
            		winblend = 0,
            		highlights = {
            			border = "Normal",
            			background = "Normal",
            		},
            	},
            })

            function _G.set_terminal_keymaps()
              local opts = {noremap = true}
              vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
              vim.api.nvim_buf_set_keymap(0, 't', 'jk', [[<C-\><C-n>]], opts)
              vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
              vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
              vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
              vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
            end

            vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

            local Terminal = require("toggleterm.terminal").Terminal
            local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })

            function _LAZYGIT_TOGGLE()
            	lazygit:toggle()
            end

            local node = Terminal:new({ cmd = "node", hidden = true })

            function _NODE_TOGGLE()
            	node:toggle()
            end

            local ncdu = Terminal:new({ cmd = "ncdu", hidden = true })

            function _NCDU_TOGGLE()
            	ncdu:toggle()
            end

            local htop = Terminal:new({ cmd = "htop", hidden = true })

            function _HTOP_TOGGLE()
            	htop:toggle()
            end

            local python = Terminal:new({ cmd = "python", hidden = true })

            function _PYTHON_TOGGLE()
            	python:toggle()
            end
          '';
        }
        SchemaStore-nvim
      ];
    extraConfig = ''
      lua << EOF
        ${builtins.readFile ./cfg/extraConfig.lua}
      EOF
    '';
  };
}
