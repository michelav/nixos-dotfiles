{
  description = "Home Flake";

  inputs = {
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/22.11";
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

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      local-overlays = import ./overlays;
      overlays = [ inputs.neovim-nightly-overlay.overlay local-overlays ];
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgs = forAllSystems (system:
        import nixpkgs {
          inherit system overlays;
          config = {
            allowUnfree = true;
            allowUnfreePredicate = _: true;
          };
        });
      mkNixos = system: modules:
        nixpkgs.lib.nixosSystem {
          inherit system modules;
          specialArgs = { inherit inputs outputs; };
        };
      homeManagerModules = import ./modules/hm;
    in {
      inherit overlays homeManagerModules;
      nixosConfigurations = {
        vega = mkNixos "x86_64-linux" [
          ./hosts/vega
          {
            nixpkgs = {
              inherit overlays;
              config.allowUnfree = true;
              config.allowUnfreePredicate = _: true;
            };
            home-manager.useGlobalPkgs = true;
          }
        ];
      };
      devShells = forAllSystems (system:
        let ps = pkgs.${system};
        in with ps; {
          default = mkShell {
            buildInputs = [ coreutils findutils gnumake nixpkgs-fmt nixFlakes ];
          };
          haskell = import ./shells/haskell.nix { pkgs = ps; };
          rust = import ./shells/rust.nix { pkgs = ps; };
          golang = import ./shells/golang.nix { pkgs = ps; };
        });
    };
}
