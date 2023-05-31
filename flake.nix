{
  description = "Home Flake";

  inputs = {
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
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
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      inherit (self) outputs;
      local-overlays = import ./overlays;
      overlays = [ inputs.neovim-nightly-overlay.overlay local-overlays ];
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      mkNixos = modules:
        nixpkgs.lib.nixosSystem {
          inherit modules;
          specialArgs = { inherit inputs outputs; };
        };
      homeManagerModules = import ./modules/hm;
    in {
      inherit overlays homeManagerModules;
      nixpkgs = {
        inherit overlays;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };
      nixosConfigurations = { vega = mkNixos [ ./hosts/vega ]; };
      devShells = forAllSystems (system:
        with pkgs; {
          default = mkShell {
            buildInputs = [ coreutils findutils gnumake nixpkgs-fmt nixFlakes ];
          };
          haskell = import ./shells/haskell.nix { inherit pkgs; };
          rust = import ./shells/rust.nix { inherit pkgs; };
          golang = import ./shells/golang.nix { inherit pkgs; };
        });
    };
}
