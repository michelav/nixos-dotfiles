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
    # {
    #   plugin = image-nvim;
    #   type = "lua";
    #   config = ''
    #     require("image").setup({
    #       backend = "kitty",
    #       integrations = {
    #         markdown = {
    #           enabled = true,
    #           clear_in_insert_mode = false,
    #           download_remote_images = true,
    #           only_render_image_at_cursor = false,
    #           filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
    #         },
    #         neorg = {
    #           enabled = true,
    #           clear_in_insert_mode = false,
    #           download_remote_images = true,
    #           only_render_image_at_cursor = false,
    #           filetypes = { "norg" },
    #         },
    #       },
    #       max_width = nil,
    #       max_height = nil,
    #       max_width_window_percentage = nil,
    #       max_height_window_percentage = 50,
    #       window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
    #       window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    #       editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
    #       tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
    #       hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" }, -- render image files as images when opened
    #     })'';
    # }
  ];
}
