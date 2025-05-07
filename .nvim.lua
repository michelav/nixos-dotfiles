local nvim_lsp = require("lspconfig")

local augroup = vim.api.nvim_create_augroup("NixdFormatting", {})

local on_attach = function(client, bufnr)
  if client:supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format()
      end,
    })
  end
end

nvim_lsp.nixd.setup({
  cmd = { "nixd" },
  on_attach = on_attach,
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
  settings = {
    nixd = {
      -- nixpkgs = {
      -- 	expr = "import (builtins.getFlake (toString ./.)).inputs.nixpkgs { }",
      -- },
      formatting = {
        command = { "nixfmt" },
      },
      -- options = {
      --   nixos = {
      --     expr = "(builtins.getFlake (toString ./.)).nixosConfigurations.vega.options",
      --   },
      --   home_manager = {
      --     expr = "(builtins.getFlake (toString ./.))..home-manager.users.type.getSubOptions []",
      --   },
      -- },
    },
  },
})
