local nvim_lsp = require("lspconfig")
nvim_lsp.nixd.setup({
	cmd = { "nixd" },
	settings = {
		nixd = {
			nixpkgs = {
				expr = "import (builtins.getFlake (toString ./.)).inputs.nixpkgs { }",
			},
			formatting = {
				command = { "nixfmt" },
			},
			options = {
				nixos = {
					expr = "(builtins.getFlake (toString ./.)).nixosConfigurations.vega.options",
				},
				home_manager = {
					expr = "(builtins.getFlake (toString ./.)).nixosConfigurations.vega.config.home_manager.users.michel",
				},
			},
		},
	},
})
