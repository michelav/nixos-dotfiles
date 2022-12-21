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

    jupyterWith = {
      url = "github:tweag/jupyterWith";
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
    devenv.url = "github:cachix/devenv/v0.4";
  };

  outputs = { nixpkgs, nixpkgs-stable, ... }@inputs:
    let
      username = "michel";
      local-lib = import ./lib { inherit inputs; };
      inherit (local-lib) mkSystem mkHome;
      local-overlays = import ./overlays;
      overlays = [
        inputs.neovim-nightly-overlay.overlay
        inputs.sops-nix.overlay
        local-overlays
        # TODO: Remove after httpie is fixed in nixpkgs-unstable
        (final: prev: {
          python310 = prev.python310.override {
            packageOverrides = pFinal: pPrev: {
              httpie = pPrev.httpie.overrideAttrs (oldAttrs: {
                disabledTests = [
                  # flaky
                  "test_stdin_read_warning"
                  # Re-evaluate those tests with the next release
                  "test_duplicate_keys_support_from_response"
                  "test_invalid_xml"
                  "test_json_formatter_with_body_preceded_by_non_json_data"
                  "test_pretty_options_with_and_without_stream_with_converter"
                  "test_response_mime_overwrite"
                  "test_terminal_output_response_charset_detection"
                  "test_terminal_output_response_charset_override"
                  "test_terminal_output_response_content_type_charset_with_stream"
                  "test_terminal_output_response_content_type_charset"
                  "test_valid_xml"
                  "test_xml_format_options"
                  "test_xml_xhtm"
                ];
              });
              # inherit (nixpkgs-stable.legacyPackages."x86_64-linux".python310Packages)
              #   httpie;
            };
          };
        })
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
    in rec {
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
