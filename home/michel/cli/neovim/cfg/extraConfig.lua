local o = vim.o
local wo = vim.wo
local set = vim.opt

-- global options
o.swapfile = true
o.dir = "/tmp"
o.smartcase = true
o.laststatus = 2
o.hlsearch = true
o.incsearch = true
o.ignorecase = true
o.scrolloff = 12
o.exrc = true

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

-- Diagnostic Signs

local signs = {
  { name = "DiagnosticSignError", text = " " },
  { name = "DiagnosticSignWarn", text = " " },
  { name = "DiagnosticSignHint", text = " " },
  { name = "DiagnosticSignInfo", text = " " },
}

for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
end

local config = {
  virtual_text = { source = "always", spacing = 5 },
  signs = {
    active = signs,
  },
  update_in_insert = true,
  underline = true,
  severity_sort = false,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
}
vim.diagnostic.config(config)

-- Global Key mappings
local map = vim.keymap.set
map("n", "<A-j>", ":m+<CR>")
map("n", "<A-k>", ":m-2<CR>")
map("i", "<A-j>", "<ESC>:m+<CR>i")
map("i", "<A-k>", "<ESC>:m-2<CR>i")
map("v", "<A-j>", ":m '>+1<CR>gv")
map("v", "<A-k>", ":m '<-2<CR>gv") -- Global mappings.
map("n", "<space>e", vim.diagnostic.open_float)
map("n", "[d", vim.diagnostic.goto_prev)
map("n", "]d", vim.diagnostic.goto_next)
map("n", "<space>ll", vim.diagnostic.setloclist)

-- Buffer key mappings
-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "v" }, "<space>ca", "<cmd>Lspsaga code_action<CR>", opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<space>f", function()
      vim.lsp.buf.format({ async = true })
    end, opts)
  end,
})
