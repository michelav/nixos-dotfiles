{ inputs, pkgs, lib, desktop, feats, ... }:
let inherit (lib) optional forEach;
in {

  # The feats dictates what should be installed
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.nix-colors.homeManagerModule
    ./hm-impermanence-optin.nix
  ] ++ forEach feats (f: ./${f})
    ++ optional (null != desktop) ./desktop/${desktop};

  home = { packages = with pkgs; [ jq ripgrep fd tree htop gcc bc ]; };

  systemd.user.startServices = "sd-switch";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
