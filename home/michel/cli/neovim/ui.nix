{ pkgs, config, ... }: {
  programs.neovim.plugins = with pkgs.vimPlugins; [

    nvim-navic # context top bar
    nvim-web-devicons
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
    {
      plugin = indent-blankline-nvim;
      type = "lua";
      config = ''
        vim.opt.list = true
        vim.opt.listchars:append("eol:↴")
        require("ibl").setup {
          indent = {
            char = "│",
          }
        }
      '';
    }
    {
      plugin = symbols-outline-nvim;
      type = "lua";
      config = ''
        require("symbols-outline").setup() 
        vim.api.nvim_set_keymap('n', '<leader>o', "<cmd>SymbolsOutline<cr>", {})
      '';
    }
    { # TODO: Integrate with Telescope
      plugin = nvim-lightbulb;
      type = "lua";
      config = ''
        require('nvim-lightbulb').setup({autocmd = {enabled = true}})
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

  ];
}
