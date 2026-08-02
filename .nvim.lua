local flake = "builtins.getFlake (toString ./.)"

vim.lsp.config("nixd", {
  settings = {
    nixd = {
      nixpkgs = {
        expr = "(" .. flake .. ").nixosConfigurations.vega.pkgs",
      },
      options = {
        nixos = {
          expr = "(" .. flake .. ").nixosConfigurations.vega.options",
        },
        ["home-manager"] = {
          expr = "(" .. flake .. ").nixosConfigurations.vega.options.home-manager.users.type.getSubOptions []",
        },
      },
    },
  },
})
