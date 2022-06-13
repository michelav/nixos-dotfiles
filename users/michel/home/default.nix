{ inputs, config, pkgs, lib, profiles, ... }:
{

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = [ inputs.neovim-nightly-overlay.overlay inputs.nur.overlay ];
  };
  
  # The profiles dictates what should be installed
  imports = [
     inputs.nix-colors.homeManagerModule
     ./profiles
  ] ++ lib.forEach profiles (p: ./profiles/. + "/${p}.nix");
  
  colorscheme = inputs.nix-colors.colorSchemes.nord;

  home = {
    # Moved to desktop
    packages = with pkgs; [
      jq
      ripgrep
      fd
      tree
      htop
      gcc
    ];
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
#  home.stateVersion = "21.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
