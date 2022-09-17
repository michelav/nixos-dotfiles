{
  description = "Basic Flake";

  inputs = {

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

    jupyterWith = {
      url = "github:tweag/jupyterWith";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nur, ... }@inputs:
    let
      username = "michel";
      local-lib = import ./lib { inherit inputs; };
      inherit (local-lib) mkSystem mkHome forAllMySystems;
      overlays = [ (import ./overlays) nur.overlay inputs.neovim.overlay ]
        ++ (builtins.attrValues inputs.jupyterWith.overlays);
      feats = [ "cli" "dev" ];
    in rec {
      legacyPackages = forAllMySystems (system:
        import nixpkgs {
          inherit system overlays;
          config.allowUnfree = true;
        });

      nixosConfigurations = {
        vega = mkSystem {
          pkgs = legacyPackages."x86_64-linux";
          hostname = "vega";
          users = [ "${username}" ];
        };
      };
      homeConfigurations = {
        "${username}@vega" = mkHome {
          inherit username feats;
          pkgs = legacyPackages."x86_64-linux";
        };
      };
      apps = forAllMySystems (system:
        let
          pkgs = legacyPackages.${system};
          iPython = pkgs.kernels.iPythonWith {
            name = "Python-env";
            packages = p: with p; [ numpy pandas scikit-learn ];
            ignoreCollisions = true;
          };
          jupyterEnvironment = pkgs.jupyterlabWith { kernels = [ iPython ]; };
        in rec {
          jupyterLab = {
            type = "app";
            program = "${jupyterEnvironment}/bin/jupyter-lab";
          };
        });
      devShells = forAllMySystems (system:
        let pkgs = legacyPackages.${system};
        in {
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
