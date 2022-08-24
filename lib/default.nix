{ inputs, ... }: {
  mkSystem = { hostname, system ? "x86_64-linux", pkgs, users ? [ ]
    , # Choose between gnome or sway
    desktop ? "sway", extraModules ? [ ] }:
    with inputs;
    nixpkgs.lib.nixosSystem {
      inherit system pkgs;
      specialArgs = { inherit system desktop inputs; };
      modules =
        [ ../system/hosts/${hostname} { networking.hostName = hostname; } ]
        ++ nixpkgs.lib.forEach users (u: import ../system/users/${u}.nix);
    };

  mkHome = { username, pkgs, system ? "x86_64-linux", desktop ? "sway"
    , feats ? [ "cli" ], }:
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
      extraSpecialArgs = { inherit system inputs desktop feats; };
    };
}
