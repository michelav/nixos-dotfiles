{ lib, ... }:
{
  imports = [
    ./_common
    ./hyprland
  ];

  xdg = {
    enable = true;
    configFile."mimeapps.list".force = true;
    mimeApps.enable = true;
    userDirs = {
      enable = true;
      setSessionVariables = false;
    };
    portal.enable = lib.mkForce true;
  };
}
