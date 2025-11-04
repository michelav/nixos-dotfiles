{
  inputs,
  pkgs,
  config,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  home.packages = [ inputs.self.packages.${system}.browseros ];
  imports = [ ./qutebrowser.nix ];
  programs = {
    browserpass.enable = true;
    brave.enable = true;
    firefox =
      let
        system = pkgs.stdenv.hostPlatform.system;
        addons = inputs.firefox-addons.packages.${system};
      in
      {
        enable = true;
        profiles.michel = {
          extensions.packages = with addons; [
            ublock-origin
            browserpass
          ];
          settings = {
            "browser.disableResetPrompt" = true;
            "browser.download.useDownloadDir" = false;
            "dom.security.https_only_mode" = true;
            "identity.fxaccounts.enabled" = false;
            "privacy.trackingprotection.enabled" = true;
            "signon.rememberSignons" = false;
            "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
            "browser.shell.checkDefaultBrowser" = false;
            "browser.shell.defaultBrowserCheckCount" = 1;
            "browser.download.panel.shown" = true;
          };
          search = {
            default = "google";
            force = true;
            engines = {
              "Nix Packages" = {
                urls = [
                  {
                    template = "https://search.nixos.org/packages";
                    params = [
                      {
                        name = "type";
                        value = "packages";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];

                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@np" ];
              };

              "NixOS Wiki" = {
                urls = [
                  {
                    template = "https://wiki.nixos.org/index.php?search={searchTerms}";
                  }
                ];
                icon = "https://wiki.nixos.org/favicon.png";
                updateInterval = 24 * 60 * 60 * 1000; # every day
                definedAliases = [ "@nw" ];
              };
            };
          };
        };
      };
    chromium = {
      enable = true;
      package = pkgs.google-chrome;
      # commandLineArgs =
      #   [ "--enable-features=UseOzonePlatform" "--ozone-platform=wayland" ];
    };
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = [
      "firefox.desktop"
      "org.qutebrowser.qutebrowser.desktop"
    ];
    "text/xml" = [
      "firefox.desktop"
      "org.qutebrowser.qutebrowser.desktop"
    ];
    "x-scheme-handler/http" = [
      "firefox.desktop"
      "org.qutebrowser.qutebrowser.desktop"
    ];
    "x-scheme-handler/https" = [
      "firefox.desktop"
      "org.qutebrowser.qutebrowser.desktop"
    ];
    "x-scheme-handler/chrome" = [ "firefox.desktop" ];
    "x-scheme-handler/qute" = [ "org.qutebrowser.qutebrowser.desktop" ];
  };

  # Impermanence
  home.persistence."/persist/home/michel" = {
    allowOther = true;
    directories = [
      ".mozilla/firefox"
      ".cache/mozilla/firefox"
      ".config/qutebrowser/bookmarks"
      ".config/qutebrowser/greasemonkey"
      ".local/share/qutebrowser"
      ".config/google-chrome"
      ".cache/google-chrome"
    ];
  };
}
