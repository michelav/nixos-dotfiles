{
  description = "Basic Flake";
  
  inputs = {
   
    # Core nix flakes
    nixpkgs.url = "nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware";
    nixpkgs-wayland.url  = "github:nix-community/nixpkgs-wayland";
 
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
          ({pkgs, config, ... }: {
            config = {
              nix = {
                # add binary caches
                binaryCachePublicKeys = [
                  "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
                  "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
                  # ...
                ];
                binaryCaches = [
                  "https://cache.nixos.org"
                  "https://nixpkgs-wayland.cachix.org"
                  # ...
                ];
              };

              # use it as an overlay
              nixpkgs.overlays = [ inputs.nixpkgs-wayland.overlay ];
            };
          })
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
