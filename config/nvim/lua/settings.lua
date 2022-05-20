local o = vim.o
local wo = vim.wo
local bo = vim.bo
local set = vim.opt
local catppuccin = require("catppuccin")

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
    -- background = "dark",
}

set.shortmess:append "c"

for key, value in pairs(options) do
    set[key] = value
end


vim.cmd[[colorscheme catppuccin]]
