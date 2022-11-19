{
  description = "Basic Flake";

  inputs = {
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    hardware.url = "github:nixos/nixos-hardware";
    impermanence.url = "github:nix-community/impermanence";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors.url = "github:misterio77/nix-colors";

    nnn-plugins = {
      url = "github:jarun/nnn/v4.5";
      flake = false;
    };

    jupyterWith = {
      url = "github:tweag/jupyterWith";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, ... }@inputs:
    let
      username = "michel";
      local-lib = import ./lib { inherit inputs; };
      inherit (local-lib) mkSystem mkHome;
      # TODO: Import local overlays
      local-overlays = import ./overlays;
      overlays = [ inputs.neovim-nightly-overlay.overlay local-overlays ];
      feats = [ "cli" "dev" ];
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      legacyPackages = forAllSystems (system:
        import nixpkgs {
          inherit system overlays;
          config.allowUnfree = true;
        });
      pkgs = legacyPackages."x86_64-linux";
    in rec {
      inherit legacyPackages;
      nixosConfigurations = {
        vega = mkSystem {
          inherit pkgs;
          hostname = "vega";
          users = [ "${username}" ];
        };
      };
      homeConfigurations = {
        "${username}@vega" = mkHome { inherit username feats pkgs; };
      };
      devShells = forAllSystems (system:
        with pkgs; {
          default = mkShell {
            buildInputs = [ coreutils findutils gnumake nixpkgs-fmt nixFlakes ];
          };
          python39 = import ./shells/python.nix { inherit pkgs; };
          haskell = import ./shells/haskell.nix { inherit pkgs; };
          rust = import ./shells/rust.nix { inherit pkgs; };
          golang = import ./shells/golang.nix { inherit pkgs; };
        });
    };
}
