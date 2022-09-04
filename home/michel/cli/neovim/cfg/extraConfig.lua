local o = vim.o
local wo = vim.wo
local bo = vim.bo
local set = vim.opt
--local catppuccin = require("catppuccin")

-- global options
o.swapfile = true
o.dir = "/tmp"
o.smartcase = true
o.laststatus = 2
o.hlsearch = true
o.incsearch = true
o.ignorecase = true
o.scrolloff = 12

-- window-local options
wo.number = false
wo.wrap = false

vim.g.mapleader = " "

vim.cmd([[set fcs=eob:\ ]])
vim.cmd([[filetype plugin indent on]])

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
	cursorline = true,
	mouse = "a",
	cmdheight = 1,
	undodir = "/tmp/.nvimdid",
	undofile = true,
	pumheight = 10,
	laststatus = 3,
	updatetime = 250,
}

set.shortmess:append("c")

for key, value in pairs(options) do
	set[key] = value
end

-- Key mappings
local km_opts = { noremap = true, silent = true }
local map = vim.api.nvim_set_keymap
map("n", "<A-j>", ":m+<CR>", km_opts)
map("n", "<A-k>", ":m-2<CR>", km_opts)
map("i", "<A-j>", "<ESC>:m+<CR>i", km_opts)
map("i", "<A-k>", "<ESC>:m-2<CR>i", km_opts)
map("v", "<A-j>", ":m '>+1<CR>gv", km_opts)
map("v", "<A-k>", ":m '<-2<CR>gv", km_opts)
