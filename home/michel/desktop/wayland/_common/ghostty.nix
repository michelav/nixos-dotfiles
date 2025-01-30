{
  pkgs,
  inputs,
  ...
}:
{
  home.packages = [ inputs.ghostty.packages.${pkgs.system}.default ];
  xdg.desktopEntries = {
    ghostty = {
      name = "Ghostty w/o titlebar";
      type = "Application";
      comment = "A terminal emulator";
      exec = "ghostty --window-decoration=false";
      icon = "com.mitchellh.ghostty";
      categories = [
        "System"
        "TerminalEmulator"
      ];
      startupNotify = true;
      terminal = false;
    };
  };
}
