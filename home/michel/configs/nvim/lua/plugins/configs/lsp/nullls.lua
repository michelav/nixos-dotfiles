local nls = require "null-ls"
local b = nls.builtins

nls.setup({
  sources = {
    b.diagnostics.chtex,
    b.formatting.prettier,
    b.diagnostics.markdownlint,
    b.formatting.markdownlint,
    b.formatting.jq,
    b.diagnostics.jsonlint,
    b.diagnostics.statix,
    b.code_actions.statix,
    b.diagnostics.deadnix,
    b.formatting.nixfmt,
    b.diagnostics.fish,
    b.formatting.fourmolu,
    b.formatting.stylua,
  }
})
