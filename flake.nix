{
  description = "Home Flake";

  inputs = {
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/23.11";
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

    wezterm-main = {
      url = "github:wez/wezterm?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neorg-overlay = {
      url = "github:nvim-neorg/nixpkgs-neorg-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
    nixd.url = "github:nix-community/nixd";

    # Cursosrs and Themes
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    diniamo-pkgs.url = "github:diniamo/niqspkgs";

    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    yazi = {
      url = "github:sxyazi/yazi";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixd,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      local-overlays = import ./overlays;
      overlays = [
        inputs.neovim-nightly-overlay.overlays.default
        inputs.neorg-overlay.overlays.default
        local-overlays
      ];
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgs = forAllSystems (
        system:
        import nixpkgs {
          inherit system overlays;
          config = {
            allowUnfree = true;
            allowUnfreePredicate = _: true;
          };
        }
      );
      mkNixos =
        system: modules:
        nixpkgs.lib.nixosSystem {
          inherit system modules;
          specialArgs = {
            inherit inputs outputs;
          };
        };
      homeManagerModules = import ./modules/hm;
      nixosModules = import ./modules/nixos;
    in
    {
      inherit overlays homeManagerModules nixosModules;
      nixosConfigurations = {
        vega = mkNixos "x86_64-linux" (
          [
            ./hosts/vega
            {
              nixpkgs = {
                inherit overlays;
                config.allowUnfree = true;
                config.allowUnfreePredicate = _: true;
              };
              home-manager.useGlobalPkgs = true;
            }
          ]
          ++ (builtins.attrValues nixosModules)
        );
      };
      devShells = forAllSystems (
        system:
        let
          ps = pkgs.${system};
        in
        with ps;
        {
          default = mkShell {
            buildInputs = [
              coreutils
              findutils
              gnumake
              nixpkgs-fmt
              nixVersions.latest
              nixd.packages.${system}.default
            ];
          };
          haskell = import ./shells/haskell.nix { pkgs = ps; };
          rust = import ./shells/rust.nix { pkgs = ps; };
          golang = import ./shells/golang.nix { pkgs = ps; };
        }
      );
    };
}
