{ inputs, ... }:
{
  mkSystem = {
    hostname,
    system ? "x86_64-linux",
    overlays ? { },
    users ?  [ ],
    # Choose between gnome or sway
    desktop ? "sway",
    extraModules ? [ ]
  }:
  with inputs; nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = { inherit system desktop inputs; };
    modules = [
      ../system/hosts/${hostname}
      {
        networking.hostName = hostname;
        nixpkgs = {
          overlays = builtins.attrValues overlays;
          config.allowUnfree = true;
        };
      }
    ] ++ nixpkgs.lib.forEach users (u: import ../system/users/${u}.nix);
  };
  
  mkHome = {
    username,
    packages,
    system ? "x86_64-linux",
    overlays ? { },
    desktop ? "sway",
    feats ? [ "cli" ],
  }:
  with inputs; home-manager.lib.homeManagerConfiguration {
    # inherit username system;
    pkgs = packages.${system};
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
