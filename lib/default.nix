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
    pkgs,
    system ? "x86_64-linux",
    overlays ? { },
    profiles ? [ "tiling-desktop" ],
  }:
  with inputs; home-manager.lib.homeManagerConfiguration {
    inherit username pkgs system;
    configuration = ../home/${username};
    homeDirectory = "/home/${username}";
    stateVersion = "21.11";
    nixpkgs = {
      overlays = builtins.attrValues overlays;
      config.allowUnfree = true;
    };
    extraSpecialArgs = { inherit system inputs profiles; };
  };
}
