local o = vim.o
local wo = vim.wo
local bo = vim.bo
local set = vim.opt
--local catppuccin = require("catppuccin")

-- global options
o.swapfile = true
o.dir = '/tmp'
o.smartcase = true
o.laststatus = 2
o.hlsearch = true
o.incsearch = true
o.ignorecase = true
o.scrolloff = 12

-- ... snip ...

-- window-local options
wo.number = false
wo.wrap = false

vim.g.mapleader = " "

vim.cmd [[set fcs=eob:\ ]]
vim.cmd [[filetype plugin indent on]]

local options = {
    termguicolors = true,
    fileencoding = "utf-8",
    backup = false,
--     swapfile = false,
--     hlsearch = true,
--    incsearch = true,
--    showmode = false,
    expandtab = true,
    shiftwidth = 2,
    tabstop = 2,
    softtabstop = 2,
    sidescrolloff = 5,
    smartindent = true,
    signcolumn = "yes",
    hidden = true,
    ignorecase = true,
    timeoutlen = 1000,
    shiftround = true,
--    smartcase = true,
    splitbelow = true,
    splitright = true,
    number = true,
    relativenumber = true,
    clipboard = "unnamedplus",
--    cursorline = true,
    mouse = "a",
    cmdheight = 1,
    undodir = "/tmp/.nvimdid",
    undofile = true,
    pumheight = 10,
    laststatus = 3,
    updatetime = 250,
}

set.shortmess:append "c"

for key, value in pairs(options) do
    set[key] = value
end

require('nightfox').setup({
  options = {
    -- Compiled file's destination location
    compile_path = vim.fn.stdpath("cache") .. "/nightfox",
    compile_file_suffix = "_compiled", -- Compiled file suffix
    transparent = false,    -- Disable setting background
    terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
    dim_inactive = false,   -- Non focused panes set to alternative background
    styles = {              -- Style to be applied to different syntax groups
      comments = "NONE",    -- Value is any valid attr-list value `:help attr-list`
      conditionals = "NONE",
      constants = "NONE",
      functions = "NONE",
      keywords = "NONE",
      numbers = "NONE",
      operators = "NONE",
      strings = "NONE",
      types = "NONE",
      variables = "NONE",
    },
    inverse = {             -- Inverse highlight for different types
      match_paren = false,
      visual = false,
      search = false,
    },
    modules = {             -- List of various plugins and additional options
      -- ...
    },
  }
})

-- setup must be called before loading
vim.cmd[[colorscheme nordfox]]
