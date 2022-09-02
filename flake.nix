{
  description = "Basic Flake";

  inputs = {

    # neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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

  outputs = { nixpkgs, nur, ... }@inputs:
    let
      system = "x86_64-linux";
      local-lib = import ./lib { inherit inputs; };
      inherit (local-lib) mkSystem mkHome;
      inherit (nixpkgs.lib) genAttrs systems;
      forAllSystems = genAttrs systems.flakeExposed;
      username = "michel";
      overlays = [
       (import ./overlays )
       nur.overlay
      inputs.neovim.overlay
       # neovim-nightly-overlay.overlay
     ]; 
     # overlays = {
       #   # Comment out to insert new overlays
       #   default = import ./overlays { inherit inputs; };
       #   nur = nur.overlay;
       #   neovim-overlay = neovim-nightly-overlay.overlay;
       # };
      feats = [ "cli" "dev" ];
    in rec {
      legacyPackages = forAllSystems (system:
        import nixpkgs {
          inherit system overlays;
          # overlays = builtins.attrValues overlays;
          config.allowUnfree = true;
        });

      nixosConfigurations = {
        vega = mkSystem {
          inherit system;
          pkgs = legacyPackages.${system};
          hostname = "vega";
          users = [ "michel" ];
        };
      };
      homeConfigurations = let pkgs = legacyPackages.${system};
      in {
        "${username}@vega" = mkHome { inherit system pkgs username feats; };
      };

      devShells = forAllSystems (system:
        let pkgs = legacyPackages.${system};
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
          python39 = import ./shells/python.nix { inherit pkgs; };
          haskell = import ./shells/haskell.nix { inherit pkgs; };
          rust = import ./shells/rust.nix { inherit pkgs; };
          golang = import ./shells/golang.nix { inherit pkgs; };
        });
    };
}
