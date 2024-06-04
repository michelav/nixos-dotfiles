vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "rounded",
})

-- if you want to set up formatting on save, you can use this as a callback
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- add to your shared on_attach callback
local format_on_save = function(bufnr)
  vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup,
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.format()
    end,
  })
end

local on_attach = function(client, bufnr)
  print("LSP Attaching to client", client.name)
  if client.supports_method("textDocument/formatting") then
    format_on_save(bufnr)
  end
  if client.server_capabilities.documentSymbolProvider then
    require("nvim-navic").attach(client, bufnr)
  end
end

-- Runtime path for lua language server
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

-- Golps customizations
local on_attach_golang = function(client, buffer)
  on_attach(client, buffer)
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup,
    buffer = buffer,
    callback = function()
      vim.lsp.buf.code_action({
        context = { only = { "source.organizeImports" }, triggerKind = 2 },
        apply = true,
      })
    end,
  })
end

local lspconfig = require("lspconfig")

local function config_lsp(server, options)
  if not options["cmd"] then
    options["cmd"] = server["document_config"]["default_config"]["cmd"]
  end
  if not options["on_attach"] then
    options["on_attach"] = on_attach
  end
  if not options["capabilities"] then
    options["capabilities"] = require("cmp_nvim_lsp").default_capabilities()
  end
  if vim.fn.executable(options["cmd"][1]) == 1 then
    server.setup(options)
  end
end

config_lsp(lspconfig.nixd, {})
config_lsp(lspconfig.dockerls, {})
config_lsp(lspconfig.hls, {})
config_lsp(lspconfig.terraformls, {})
config_lsp(lspconfig.rust_analyzer, {})
config_lsp(lspconfig.yamlls, {})
config_lsp(lspconfig.texlab, {})
config_lsp(lspconfig.ccls, {})
config_lsp(lspconfig.jsonls, {})
config_lsp(lspconfig.gopls, { on_attach = on_attach_golang })
config_lsp(lspconfig.lua_ls, {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        -- Avoid 'Configure work environment' questions when opening lua files
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
})
config_lsp(lspconfig.ruff_lsp, {
  options = {
    on_attach = function(client, buffer)
      if client.name == "ruff_lsp" then
        -- Disable hover in favor of Pyright
        client.server_capabilities.hoverProvider = false
      end
    end,
  },
})
config_lsp(lspconfig.pyright, {
  settings = {
    pyright = {
      -- Using Ruff's import organizer
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        -- Ignore all files for analysis to exclusively use Ruff for linting
        ignore = { "*" },
      },
    },
  },
})
