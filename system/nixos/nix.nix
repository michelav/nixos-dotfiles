{pkgs, inputs, lib, config, ...}:
{
  nix = {
    package = pkgs.nixFlakes; # or versioned attributes like nix_2_7
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
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
