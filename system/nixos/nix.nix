{ pkgs, inputs, lib, config, ... }: {
  nix = {
    settings = {
      substituters = [
        "https://nix-community.cachix.org"
        "https://misterio.cachix.org"
        "https://michelav.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "michelav.cachix.org-1:nWCV2A3/ZUVYtNcJqzNv4nGxpNipH4aYJ4XQ2ZCQuIM="
      ];
      trusted-users = [ "root" "@wheel" ];
      experimental-features = [ "nix-command" "flakes" ];
    };
    package = pkgs.nixUnstable; # or versioned attributes like nix_2_7
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
    # Set the $NIX_PATH entry for nixpkgs. This is necessary in
    # this setup with flakes, otherwise commands like `nix-shell
    # -p pkgs.htop` will keep using an old version of nixpkgs
    nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
      # "nixpkgs-unstable=${inputs.unstable}"
    ];
    # Same as above, but for `nix shell nixpkgs#htop`
    # FIXME: for non-free packages you need to use `nix shell --impure`
    registry = {
      nixpkgs.flake = inputs.nixpkgs;
      # nixpkgs-unstable.flake = inputs.unstable;
    };
  };
}
