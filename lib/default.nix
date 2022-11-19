{ inputs, ... }: {
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
          nixpkgs.config.allowUnfree = true;
          home = {
            inherit username;
            homeDirectory = "/home/${username}";
            stateVersion = "22.05";
          };

        }
        ../modules/fontConfigs.nix
        ../modules/hm
      ];
      extraSpecialArgs = { inherit inputs desktop feats; };
    };
}
