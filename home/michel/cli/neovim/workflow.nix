{ pkgs, ... }: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
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
    {
      plugin = leap-nvim;
      type = "lua";
      config = ''
        require('leap').add_default_mappings()
      '';
    }
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
    {
      plugin = telescope-nvim;
      type = "lua";
      config = builtins.readFile ./cfg/telescope.lua;
    }
    telescope-fzf-native-nvim
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
    {
      plugin = orgmode;
      type = "lua";
      config = # lua
        ''
          local orgmode = require('orgmode')
          orgmode.setup{
            org_agenda_files = '~/Dropbox/Org/*',
            org_default_notes_file = '~/Dropbox/Org/notes.org',
            org_capture_templates = {
              t = {
                description = 'Task',
                template = '* TODO %?\n %u',
                target = '~/Dropbox/Org/todo.org'
              },
              j = {
                description = 'Journal',
                template = '\n*** %<%Y-%m-%d> %<%A>\n**** %U\n\n%?',
                target = '~/Dropbox/Org/journal.org'
              },
            },
          }
        '';
    }
    {
      plugin = neorg;
      type = "lua";
      config = # lua
        ''
          require("neorg").setup {
            load = {
              ["core.defaults"] = {},
              ["core.concealer"] = {},
              ["core.dirman"] = {
                config = {
                  workspaces = {
                    notes = "~/notes",
                  },
                  default_workspace = "notes",
                },
              },
            },
          }
        '';
    }
    neorg-telescope
  ];
}
