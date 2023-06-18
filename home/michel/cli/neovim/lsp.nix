{ pkgs, ... }: {
  programs.neovim.plugins = with pkgs.vimPlugins; [

    {
      plugin = nvim-lspconfig;
      type = "lua";
      config = builtins.readFile ./cfg/lsp.lua;
    }

    {
      plugin = null-ls-nvim;
      type = "lua";
      config = ''
        local nls = require "null-ls"
        local f = nls.builtins.formatting
        local d = nls.builtins.diagnostics
        local ca = nls.builtins.code_actions
        nls.setup({
        sources = {
        f.prettier,
        f.jq,
        f.markdownlint,
        f.stylua,
        f.nixfmt,
        d.markdownlint,
        d.jsonlint,
        d.statix,
        d.deadnix,
        d.fish,
        ca.statix,
        }
        })
      '';
    }

    {
      plugin = nvim-cmp;
      type = "lua";
      config = builtins.readFile ./cfg/cmp.lua;
    }

    cmp-nvim-lsp
    cmp-nvim-lua
    cmp-treesitter
    cmp-path
    cmp-buffer
    cmp-vsnip
    luasnip
    cmp_luasnip
    cmp-nvim-lsp-document-symbol
    cmp-cmdline
    friendly-snippets
    rust-tools-nvim
  ];
}
