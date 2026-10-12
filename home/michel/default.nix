{
  inputs,
  outputs,
  lib,
  ...
}:
{

  # The feats dictates what should be installed
  imports = [
    inputs.stylix.homeModules.stylix
    inputs.sops-nix.homeManagerModules.sops
    ./hm-impermanence-optin.nix
    ./apps
    ./cli
    ./cloud
    ./dev
    ./desktop/wayland
    ./gaming
    ./media
    ./writing
    ./research
    ./agents
  ]
  ++ (builtins.attrValues outputs.homeManagerModules);

  home = {
    username = "michel";
    homeDirectory = "/home/michel";
    stateVersion = "23.05";
  };

  systemd.user.startServices = "sd-switch";

  userPrefs = {
    enable = true;
    editor = "vim";
    browser = "firefox";
    terminal = "wezterm";
    desktopShell = "quickshell";
  };
  # Prebuilt light variant. `theme-mode` (darkman) activates it at runtime;
  # the base generation is dark.
  specialisation.light.configuration.userPrefs.theme.mode = lib.mkForce "light";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
