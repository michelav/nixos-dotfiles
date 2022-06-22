{config, pkgs, lib, ... }:
{
  imports = [
    ../sway
  ];

  home.packages = with pkgs; [
    pavucontrol
  ];
  programs.nnn.enable = true;

  services.gpg-agent.enableSshSupport = true;
}
