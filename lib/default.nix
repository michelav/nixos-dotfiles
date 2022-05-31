{ inputs, ... }:
{
  mkSystem = {
    hostname,
    system ? "x86_64-linux",
    overlays ? { },
    users ?  [ ],
    extraModules ? [ ]
  }:
  with inputs; nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = { inherit system inputs; };
    modules = [
      ../hosts/${hostname}
      {
        networking.hostName = hostname;
        nixpkgs = {
          overlays = builtins.attrValues overlays;
          config.allowUnfree = true;
        };
      }
    ] ++ nixpkgs.lib.forEach users (u: import ../users/${u}/system);
  };
  
  mkHome = {
    username,
    pkgs,
    system ? "x86_64-linux",
    overlays ? { },
    desktop ? "sway",
  }:
  with inputs; home-manager.lib.homeManagerConfiguration {
    inherit username pkgs system;
    configuration = ../users/${username}/home;
    homeDirectory = "/home/${username}";
    stateVersion = "21.11";
    extraSpecialArgs = { inherit system desktop inputs; };
  };
}
