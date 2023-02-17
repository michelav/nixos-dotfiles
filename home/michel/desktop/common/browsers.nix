{ inputs, pkgs, config, ... }: {
  imports = [ ./qutebrowser.nix ];
  home.sessionVariables = { BROWSER = "firefox"; };
  programs = {
    browserpass.enable = true;
    brave.enable = true;
    firefox = let addons = inputs.firefox-addons.packages.${pkgs.system};
    in {
      enable = true;
      profiles.michel = {
        extensions = with addons; [
          keepassxc-browser
          ublock-origin
          netflix-1080p
          browserpass
          tridactyl
        ];
        settings = {
          "browser.disableResetPrompt" = true;
          "browser.download.useDownloadDir" = false;
        };
        search = {
          default = "Google";
          force = true;
          engines = {
            "Nix Packages" = {
              urls = [{
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
              }];

              icon =
                "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };

            "NixOS Wiki" = {
              urls = [{
                template = "https://nixos.wiki/index.php?search={searchTerms}";
              }];
              iconUpdateURL = "https://nixos.wiki/favicon.png";
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
      commandLineArgs =
        [ "--enable-features=UseOzonePlatform" "--ozone-platform=wayland" ];
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
