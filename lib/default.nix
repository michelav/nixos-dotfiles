{ inputs, ... }: {
  mkSystem = { hostname, pkgs, desktop ? "wayland" }:
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
        inputs.home-manager.nixosModules.home-manager
      ];
    };

  mkHome = { username, pkgs, desktop ? "wayland", feats ? [ "cli" ] }:
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
            stateVersion = "23.05";
          };

        }
        ../modules/hm
      ];
      extraSpecialArgs = { inherit inputs desktop feats; };
    };
}
