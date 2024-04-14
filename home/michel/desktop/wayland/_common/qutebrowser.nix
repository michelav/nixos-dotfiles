# Color configuration extracted from https://github.com/Misterio77/nix-config
{ pkgs, config, ... }:
let
  inherit (config.colorscheme) variant;
  colors = config.colorscheme.palette;
in {
  programs.qutebrowser = {
    enable = true;
    loadAutoconfig = true;
    package = pkgs.qutebrowser;
    searchEngines = {
      wiki =
        "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
      aw = "https://wiki.archlinux.org/?search={}";
      # nw = "https://nixos.wiki/index.php?search={}";
      nw = "https://wiki.nixos.org/w/index.php?search={}";
      nd = "https://discourse.nixos.org/search?q={}";
      gh = "https://github.com/search?q={}";
      np =
        "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={}";
      no =
        "https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={}";
      google = "https://www.google.com/search?hl=en&q={}";
      mw = "https://www.merriam-webster.com/thesaurus/{}";
      linguee =
        "https://www.linguee.com.br/portugues-ingles/search?source=auto&query={}";
    };
    settings = {
      content.javascript.clipboard = "access-paste";
      scrolling.smooth = true;
      colors = {
        webpage = { preferred_color_scheme = variant; };
        completion = {
          fg = "#${colors.base05}";
          match.fg = "#${colors.base09}";
          even.bg = "#${colors.base00}";
          odd.bg = "#${colors.base00}";
          scrollbar = {
            bg = "#${colors.base00}";
            fg = "#${colors.base05}";
          };
          category = {
            bg = "#${colors.base00}";
            fg = "#${colors.base0D}";
            border = {
              bottom = "#${colors.base00}";
              top = "#${colors.base00}";
            };
          };
          item.selected = {
            bg = "#${colors.base02}";
            fg = "#${colors.base05}";
            match.fg = "#${colors.base05}";
            border = {
              bottom = "#${colors.base02}";
              top = "#${colors.base02}";
            };
          };
        };
        contextmenu = {
          disabled = {
            bg = "#${colors.base01}";
            fg = "#${colors.base04}";
          };
          menu = {
            bg = "#${colors.base00}";
            fg = "#${colors.base05}";
          };
          selected = {
            bg = "#${colors.base02}";
            fg = "#${colors.base05}";
          };
        };
        downloads = {
          bar.bg = "#${colors.base00}";
          error.fg = "#${colors.base08}";
          start = {
            bg = "#${colors.base0D}";
            fg = "#${colors.base00}";
          };
          stop = {
            bg = "#${colors.base0C}";
            fg = "#${colors.base00}";
          };
        };
        hints = {
          bg = "#${colors.base0A}";
          fg = "#${colors.base00}";
          match.fg = "#${colors.base05}";
        };
        keyhint = {
          bg = "#${colors.base00}";
          fg = "#${colors.base05}";
          suffix.fg = "#${colors.base05}";
        };
        messages = {
          error = {
            bg = "#${colors.base08}";
            border = "#${colors.base08}";
            fg = "#${colors.base00}";
          };
          info = {
            bg = "#${colors.base00}";
            border = "#${colors.base00}";
            fg = "#${colors.base05}";
          };
          warning = {
            bg = "#${colors.base0E}";
            border = "#${colors.base0E}";
            fg = "#${colors.base00}";
          };
        };
        prompts = {
          bg = "#${colors.base00}";
          fg = "#${colors.base05}";
          border = "#${colors.base00}";
          selected.bg = "#${colors.base02}";
        };
        statusbar = {
          caret = {
            bg = "#${colors.base00}";
            fg = "#${colors.base0D}";
            selection.bg = "#${colors.base00}";
            selection.fg = "#${colors.base0D}";
          };
          command = {
            bg = "#${colors.base01}";
            fg = "#${colors.base04}";
            private.bg = "#${colors.base01}";
            private.fg = "#${colors.base0E}";
          };
          insert.bg = "#${colors.base00}";
          insert.fg = "#${colors.base0C}";
          normal.bg = "#${colors.base00}";
          normal.fg = "#${colors.base05}";
          passthrough.bg = "#${colors.base00}";
          passthrough.fg = "#${colors.base0A}";
          private.bg = "#${colors.base00}";
          private.fg = "#${colors.base0E}";
          progress.bg = "#${colors.base0D}";
          url = {
            error.fg = "#${colors.base08}";
            fg = "#${colors.base05}";
            hover.fg = "#${colors.base09}";
            success.http.fg = "#${colors.base0B}";
            success.https.fg = "#${colors.base0B}";
            warn.fg = "#${colors.base0E}";
          };
        };
        tabs = {
          bar.bg = "#${colors.base00}";
          even.bg = "#${colors.base00}";
          even.fg = "#${colors.base05}";
          indicator = {
            error = "#${colors.base08}";
            start = "#${colors.base0D}";
            stop = "#${colors.base0C}";
          };
          odd.bg = "#${colors.base00}";
          odd.fg = "#${colors.base05}";
          pinned = {
            even.bg = "#${colors.base0B}";
            even.fg = "#${colors.base00}";
            odd.bg = "#${colors.base0B}";
            odd.fg = "#${colors.base00}";
            selected = {
              even.bg = "#${colors.base02}";
              even.fg = "#${colors.base05}";
              odd.bg = "#${colors.base02}";
              odd.fg = "#${colors.base05}";
            };
          };
          selected = {
            even.bg = "#${colors.base02}";
            even.fg = "#${colors.base05}";
            odd.bg = "#${colors.base02}";
            odd.fg = "#${colors.base05}";
          };
        };
      };
    };
  };
}
