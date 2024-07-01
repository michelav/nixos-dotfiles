{
  pkgs,
  inputs,
  lib,
  ...
}:
let
  flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
in
{
  nix = {
    settings = {
      substituters = [
        "https://nix-community.cachix.org"
        "https://misterio.cachix.org"
        "https://michelav.cachix.org"
        "https://devenv.cachix.org"
        "https://cache.iog.io"
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "michelav.cachix.org-1:nWCV2A3/ZUVYtNcJqzNv4nGxpNipH4aYJ4XQ2ZCQuIM="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    package = pkgs.nixVersions.latest;
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
    # All Inputs and self flakes are available as registries and nicPath
    registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };
}
