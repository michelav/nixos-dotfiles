{
  description = "Home Flake";

  inputs = {
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      # TODO: Remove workaround after this is handled
      # https://github.com/nix-community/neovim-nightly-overlay/issues/164
      /* inputs.nixpkgs.url =
         "github:nixos/nixpkgs?rev=fad51abd42ca17a60fc1d4cb9382e2d79ae31836";
      */

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
    devenv.url = "github:cachix/devenv/v0.4";
  };

  outputs = { nixpkgs, ... }@inputs:
    let
      username = "michel";
      local-lib = import ./lib { inherit inputs; };
      inherit (local-lib) mkSystem mkHome;
      local-overlays = import ./overlays;
      overlays = [
        inputs.neovim-nightly-overlay.overlay
        inputs.sops-nix.overlay
        local-overlays
      ];
      feats = [ "cli" "dev" ];
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      legacyPackages = forAllSystems (system:
        import nixpkgs {
          inherit system overlays;
          config.allowUnfree = true;
        });
      pkgs = legacyPackages."x86_64-linux";
    in {
      inherit legacyPackages;
      packages = forAllSystems
        (system: { inherit (inputs.devenv.packages.${system}) devenv; });
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
          sops-nix = mkShell {
            name = "sops-nix";
            nativeBuildInputs = [
              age
              gnupg
              sops
              sops-install-secrets
              sops-init-gpg-key
              sops-import-keys-hook
              ssh-to-age
              ssh-to-pgp
            ];
          };
        });
    };
}
