{
  description = "Basic Flake";

  inputs = {

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    # Core nix flakes
    # nixpkgs.url = "nixpkgs/nixos-21.11";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
     nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, home-manager, neovim-nightly-overlay, nur, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };
    local-lib = import ./lib { inherit inputs; };
    inherit (local-lib) mkSystem mkHome;
    username = "michel";
    overlays = {
      nur = nur.overlay;
    };
  in
  {
    nixosConfigurations = {
      vega = mkSystem {
        inherit system overlays;
        hostname = "vega";
        users = [ "michel" ];
      };
    };
    homeConfigurations = {
    "${username}@vega" = mkHome {
        inherit system pkgs username overlays;
    };
   };
  };
}
