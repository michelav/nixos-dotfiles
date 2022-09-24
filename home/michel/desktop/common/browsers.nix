{ pkgs, config, ... }: {
  home.packages = [ pkgs.qutebrowser ];
  home.sessionVariables = { BROWSER = "firefox"; };
  programs = {
    brave.enable = true;
    firefox = {
      enable = true;

      package = pkgs.firefox-wayland.override {
        cfg = { enableGnomeExtensions = true; };
      };
    };
    chromium = {
      enable = true;
      package = pkgs.google-chrome;
    };
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = [ "firefox.desktop" "org.qutebrowser.qutebrowser.desktop" ];
    "text/xml" = [ "firefox.desktop" "org.qutebrowser.qutebrowser.desktop" ];
    "x-scheme-handler/http" =
      [ "firefox.desktop" "org.qutebrowser.qutebrowser.desktop" ];
    "x-scheme-handler/https" =
      [ "firefox.desktop" "org.qutebrowser.qutebrowser.desktop" ];
    "x-scheme-handler/chrome" = [ "firefox.desktop" ];
    "x-scheme-handler/qute" = [ "org.qutebrowser.qutebrowser.desktop" ];
  };
}
