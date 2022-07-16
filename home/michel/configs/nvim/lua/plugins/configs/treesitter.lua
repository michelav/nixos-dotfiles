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

