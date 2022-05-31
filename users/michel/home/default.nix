{ inputs, config, pkgs, ... }:
{

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = [ inputs.neovim-nightly-overlay.overlay inputs.nur.overlay ];
  };

  imports = [
      ./desktop.nix
 ];


  home = {

   username = "michel";
   homeDirectory = "/home/michel";

  # Moved to desktop
   packages = with pkgs; [
      keepassxc
      neofetch
      jq
      pavucontrol
      spotify
      playerctl
      ripgrep
      fd
      tree
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
  home.stateVersion = "21.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
