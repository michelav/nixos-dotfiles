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
	if client.supports_method("textDocument/formatting") then
		format_on_save(bufnr)
	end
	if client.server_capabilities.documentSymbolProvider then
		require("nvim-navic").attach(client, bufnr)
	end
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()
-- capabilities.textDocument.completion.completionItem.snippetSupport = true

-- default opts for language servers
local opts = {
	on_attach = on_attach,
	capabilities = capabilities,
}
--
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
			vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
		end,
	})
end

local servers = {
	{ cmd = "nixd", name = "nixd", options = opts },
	-- { cmd = "nil",                             name = "nil_ls",        options = opts },
	{ cmd = "docker-langserver", name = "dockerls", options = opts },
	{ cmd = "haskell-language-server-wrapper", name = "hls", options = opts },
	{ cmd = "terraform-ls", name = "terraformls", options = opts },
	{ cmd = "rust_analyzer", name = "rust_analyzer", options = opts },
	{ cmd = "yaml-language-server", name = "yamlls", options = opts },
	{ cmd = "texlab", name = "texlab", options = opts },
	{ cmd = "ccls", name = "ccls", options = opts },
	{ cmd = "vscode-json-language-server", name = "jsonls", options = opts },
	{
		cmd = "gopls",
		name = "gopls",
		options = { on_attach = on_attach_golang, capabilities = capabilities },
	},
	{
		cmd = "lua-language-server",
		name = "lua_ls",
		options = {
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				Lua = {
					--[[ runtime = {
            version = "LuaJIT",
            path = runtime_path,
          }, ]]
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
		},
	},
}

local lspconfig = require("lspconfig")
for _, server in ipairs(servers) do
	if vim.fn.executable(server.cmd) == 1 then
		lspconfig[server.name].setup(server.options)
	end
end
