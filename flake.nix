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
      lib = nixpkgs.lib;
      username = "michel";
    in
    {
     nixosConfigurations = {
      vega = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          ./hosts/vega
          { nixpkgs.overlays = [ nur.overlay ]; }
        ];
      };
     };
    homeConfigurations.michel = home-manager.lib.homeManagerConfiguration {
        inherit system pkgs username;
        homeDirectory = "/home/${username}";
        configuration =  import ./home;
        stateVersion = "21.11";
        extraSpecialArgs = { inherit inputs; };
    };
   };
}
