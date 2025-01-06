{ pkgs, ... }:
{
  home.packages =
    with pkgs;
    with nodePackages;
    [
      # language servers
      lua-language-server
      nil
      dockerfile-language-server-nodejs
      vscode-langservers-extracted
      yaml-language-server
      gopls
      ccls
      jsonlint
      prettier
      markdownlint-cli
      stylua

      # Python Stuff
      pyright
      black
      ruff
      ruff-lsp

      # javascript and typescript
      biome
    ];

  programs.neovim.plugins = with pkgs.vimPlugins; [

    {
      plugin = nvim-lspconfig;
      type = "lua";
      config = builtins.readFile ./cfg/lsp.lua;
    }
    {
      plugin = lspsaga-nvim;
      type = "lua";
      config = ''
        require('lspsaga').setup({})
      '';
    }

    {
      plugin = none-ls-nvim;
      type = "lua";
      config = ''
        local nls = require "null-ls"
        local f = nls.builtins.formatting
        local d = nls.builtins.diagnostics
        local ca = nls.builtins.code_actions
        nls.setup({
        sources = {
        f.black,

        f.prettier.with({ filetypes = {"html", "markdown"}}),
        f.markdownlint,
        f.stylua,
        f.nixfmt,
        d.markdownlint,
        d.statix,
        d.deadnix,
        d.fish,
        ca.statix,
        }
        })
      '';
    }
    lspkind-nvim
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
    {
      plugin = rust-tools-nvim;
      type = "lua";
      config = # lua
        ''
          local rust_tools = require('rust-tools')
          if vim.fn.executable("rust-analyzer") == 1 then
            rust_tools.setup{ tools = { autoSetHints = true } }
          end
          vim.api.nvim_set_hl(0, '@lsp.type.comment.rust', {})
        '';
    }
  ];
}
