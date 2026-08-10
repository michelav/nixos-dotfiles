{
  description = "Home Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wezterm-main = {
      url = "github:wez/wezterm?dir=nix";
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
    };
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
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

    nixvim-config = {
      url = "github:michelav/nixvim-config";
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
      pkgsOverlays = [
        local-overlays
      ];
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgs = forAllSystems (
        system:
        import nixpkgs {
          inherit system;
          overlays = pkgsOverlays;
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
    in
    {
      overlays = {
        default = local-overlays;
      };
      inherit homeManagerModules;
      formatter = forAllSystems (system: pkgs.${system}.nixfmt);
      checks = forAllSystems (
        system:
        let
          ps = pkgs.${system};
          qmlSource = ./home/michel/desktop/wayland/shell/quickshell/qml;
        in
        {
          quickshell-qml-lint =
            ps.runCommand "quickshell-qml-lint"
              {
                nativeBuildInputs = [ ps.qt6.qtdeclarative ];
              }
              ''
                if ${ps.gnugrep}/bin/grep -Eq 'property[[:space:]]+color[[:space:]]+on[A-Z]' ${./home/michel/desktop/wayland/shell/quickshell/theme.nix}; then
                  echo "Theme token names beginning with on[A-Z] collide with QML signal-handler syntax" >&2
                  exit 1
                fi
                qmllint -I ${ps.quickshell}/lib/qt-6/qml $(${ps.findutils}/bin/find ${qmlSource} -name '*.qml' -type f)
                touch $out
              '';
          quickshell-qml-format =
            ps.runCommand "quickshell-qml-format"
              {
                nativeBuildInputs = [ ps.qt6.qtdeclarative ];
              }
              ''
                while IFS= read -r file; do
                  qmlformat "$file" > /dev/null
                done < <(${ps.findutils}/bin/find ${qmlSource} -name '*.qml' -type f)
                touch $out
              '';
        }
      );
      nixosConfigurations = {
        vega = mkNixos "x86_64-linux" [
          ./hosts/vega
          {
            nixpkgs = {
              overlays = pkgsOverlays;
              config.allowUnfree = true;
              config.allowUnfreePredicate = _: true;
            };
            home-manager.useGlobalPkgs = true;
          }
        ];
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
              nixpkgs-track
              nixpkgs-fmt
              nixfmt-tree
              nixVersions.latest
              nixd.packages.${system}.default
              age
              sops
            ];
          };
          haskell = import ./shells/haskell.nix { pkgs = ps; };
          rust = import ./shells/rust.nix { pkgs = ps; };
          golang = import ./shells/golang.nix { pkgs = ps; };
          python = import ./shells/python.nix { pkgs = ps; };
        }
      );
    };
}
