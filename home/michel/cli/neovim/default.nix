{ config, pkgs, ... }: {
  home.sessionVariables.EDITOR = "nvim";

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

  programs.neovim = let
    nvimExtraPlugins = pkgs.callPackage ./extraPlugins.nix { inherit pkgs; };
  in {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs;
      with vimPlugins; [

        ########
        # Basic
        ########
        vimtex
        {
          plugin = telescope-nvim;
          type = "lua";
          config = builtins.readFile ./cfg/telescope.lua;
        }
        telescope-fzf-native-nvim
        plenary-nvim
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
        vim-fugitive
        {
          plugin = comment-nvim;
          type = "lua";
          config = ''
            require('Comment').setup()
          '';
        }

        ##############################
        # UI, Outlines, Icons, Status, Themes
        ##############################
        {
          plugin = symbols-outline-nvim;
          type = "lua";
          config = ''
            require("symbols-outline").setup() 
            vim.api.nvim_set_keymap('n', '<leader>o', "<cmd>SymbolsOutline<cr>", {})
          '';
        }
        nvim-navic
        nvim-web-devicons
        /* {
           plugin = feline-nvim;
           type = "lua";
           config = ''
           require("feline").setup({
           components = require('catppuccin.core.integrations.feline'),
           })
           '';
           }
        */
        {
          plugin = nvim-colorizer-lua;
          type = "lua";
          config = ''
            require("colorizer").setup({})
          '';
        }
        {
          plugin = lualine-nvim;
          type = "lua";
          config = builtins.readFile ./cfg/bars.lua;
        }
        /* {
           plugin = nvimExtraPlugins.nightfox-main;
           type = "lua";
           config = ''
           vim.cmd("colorscheme nordfox")
           '';
           }
        */

        nvimExtraPlugins.nvim-catppuccin
        nord-nvim
        nvimExtraPlugins.onenord
        {
          plugin = nvim-base16;
          type = "lua";
          config = ''
            vim.cmd('colorscheme base16-nord')
          '';
        }

        ############
        # LSP Stuff
        ############
        {
          plugin = nvim-lspconfig;
          type = "lua";
          config = builtins.readFile ./cfg/lsp.lua;
        } # Org mode
        {
          plugin = orgmode;
          type = "lua";
          config = # lua
            ''
              local orgmode = require('orgmode')
              orgmode.setup_ts_grammar()
              orgmode.setup{
                org_agenda_files = '~/Documents/Org/*',
                org_default_notes_file = '~/Documents/Org/captures.org',
              }
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
        {
          plugin = nvim-lightbulb;
          type = "lua";
          config = ''
            require('nvim-lightbulb').setup({autocmd = {enabled = true}})
          '';
        }
        vim-nix
        rust-tools-nvim
        yuck-vim

        ################
        ## Utils
        ################
        {
          plugin = nvim-surround;
          type = "lua";
          config = ''
            require('nvim-surround').setup({})
          '';
        }
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
        SchemaStore-nvim

        #############
        # Tree sitter
        #############
        nvim-treesitter-textobjects
        playground
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
              opt.foldmethod = "expr"
              opt.foldexpr = "nvim_treesitter#foldexpr()"
              opt.foldlevel       = 99  
          '';
        }
        {
          plugin = nvim-tree-lua;
          type = "lua";
          config = ''
            require("nvim-tree").setup({
              actions = {
                open_file = {
                  quit_on_open = true,
                },
              },
            })
            local opts = { noremap = true, silent = true }
            local keymap = vim.api.nvim_set_keymap
            keymap("n", "<leader>e", ":NvimTreeFindFileToggle<cr>", opts)
          '';
        }
        {
          plugin = leap-nvim;
          type = "lua";
          config = ''
            require('leap').add_default_mappings()
          '';
        }

        ##############
        # Completions
        ##############
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
        {
          plugin = todo-comments-nvim;
          type = "lua";
          config = ''
            require("todo-comments").setup {}
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

        ########
        # Themes
        ########
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
      ];
    extraConfig = ''
      lua << EOF
        ${builtins.readFile ./cfg/extraConfig.lua}
      EOF
    '';
  };
}
