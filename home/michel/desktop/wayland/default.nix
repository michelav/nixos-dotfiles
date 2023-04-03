{
  imports = [ ./_common ./sway ./hyprland ];

  xdg = {
    enable = true;
    configFile."mimeapps.list".force = true;
    mimeApps.enable = true;
    userDirs = { enable = true; };
  };
}
