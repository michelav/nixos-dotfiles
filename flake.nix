{
  description = "Basic Flake";
  
  inputs = {
   
    # Core nix flakes
    nixpkgs.url = "nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware";
 
    # Home manager flake
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: 
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
          ./system/configuration.nix
        ];
      };   
     };

     homeConfigurations.michel = home-manager.lib.homeManagerConfiguration {
        inherit system pkgs username;
        homeDirectory = "/home/${username}";
        configuration =  {
           imports = [
             ./user/home.nix
             ./user/sway.nix
           ];
        };
        stateVersion = "21.11";
        extraSpecialArgs = { inherit inputs; };    
    };
   };
}
