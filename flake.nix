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
    nix-colors.url = "github:misterio77/nix-colors";
    
    nnn-plugins = {
      url = "github:jarun/nnn/v4.5";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, neovim-nightly-overlay, nur, ... }@inputs:
  let
   system = "x86_64-linux";
   local-lib = import ./lib { inherit inputs; };
   inherit (local-lib) mkSystem mkHome;
   inherit (nixpkgs.lib) genAttrs systems;
   forAllSystems = genAttrs systems.flakeExposed;
   username = "michel";
   overlays = {
      nur = nur.overlay;
      neovim-overlay = neovim-nightly-overlay.overlay;
   };
   feats = [ "cli" "dev" ];
  in
  rec {
   packages = forAllSystems (system: import nixpkgs {
      inherit system;
      overlays = builtins.attrValues overlays;
      config.allowUnfree = true;
   });

    nixosConfigurations = {
      vega = mkSystem {
        inherit system overlays;
        hostname = "vega";
        users = [ "michel" ];
      };
    };
    homeConfigurations = {
      "${username}@vega" = mkHome {
        inherit system packages username feats overlays;
      };
    };

    devShells = forAllSystems (system: 
    let
      pkgs = packages.${system};
    in { 
      inherit pkgs;
      default = pkgs.mkShell {
        buildInputs = with pkgs; [
          coreutils
          findutils
          gnumake
          nixpkgs-fmt
          nixFlakes
        ];
      };
      python39 = import ./shells/python.nix { pkgs = packages.${system}; }; 
      haskell = import ./shells/haskell.nix { pkgs = packages.${system}; };
    });
  };
}
