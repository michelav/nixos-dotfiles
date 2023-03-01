{ inputs, ... }: {
  mkSystem = { hostname, pkgs, desktop ? "sway" }:
    with inputs;
    let inherit (nixpkgs.lib) nixosSystem;
    in nixosSystem {
      inherit pkgs;
      specialArgs = { inherit desktop inputs; };
      modules = [
        ../hosts/common/global
        ../hosts/${hostname}
        { networking.hostName = hostname; }
        ../hosts/common/users
      ];
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
            stateVersion = "22.11";
          };

        }
        ../modules/fontConfigs.nix
        ../modules/hm
      ];
      extraSpecialArgs = { inherit inputs desktop feats; };
    };
}
