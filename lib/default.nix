{ inputs, ... }: {
  # Place a new system architecture in the list as needed
  forAllMySystems = inputs.nixpkgs.lib.genAttrs [ "x86_64-linux" ];

  mkSystem =
    { hostname, pkgs, users ? [ ], desktop ? "sway", extraModules ? [ ] }:
    with inputs;
    let inherit (nixpkgs.lib) nixosSystem forEach;
    in nixosSystem {
      inherit pkgs;
      specialArgs = { inherit desktop inputs; };
      modules =
        [ ../system/hosts/${hostname} { networking.hostName = hostname; } ]
        ++ (forEach users (u: import ../system/users/${u}.nix));
    };

  mkHome = { username, pkgs, desktop ? "sway", feats ? [ "cli" ] }:
    with inputs;
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ../home/${username}
        {
          home = {
            inherit username;
            homeDirectory = "/home/${username}";
            stateVersion = "22.05";
          };

        }
        ../modules/fontConfigs.nix
      ];
      extraSpecialArgs = { inherit inputs desktop feats; };
    };
}
