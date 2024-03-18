# .nixd.nix
{
  eval = {
    # Example target for writing a package.
    target = {
      args = [ "-f" "default.nix" ];
      installable = "";
    };
  };
  formatting.command = "nixfmt";
  options = {
    enable = true;
    target = {
      args = [ ];
      # Example installable for flake-parts, nixos, and home-manager

      # nixOS configuration
      installable = ".#nixosConfigurations.vega.options";
    };
  };
}
