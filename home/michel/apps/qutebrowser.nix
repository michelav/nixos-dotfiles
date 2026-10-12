{ pkgs, lib, ... }:
{
  stylix.targets.qutebrowser.enable = true;

  home.packages = [ pkgs.adwaita-qt6 ];
  programs.qutebrowser = {
    enable = true;
    loadAutoconfig = true;
    package = pkgs.qutebrowser;
    searchEngines = {
      wiki = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
      aw = "https://wiki.archlinux.org/?search={}";
      nw = "https://wiki.nixos.org/w/index.php?search={}";
      nd = "https://discourse.nixos.org/search?q={}";
      gh = "https://github.com/search?q={}";
      np = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={}";
      no = "https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={}";
      google = "https://www.google.com/search?hl=en&q={}";
      mw = "https://www.merriam-webster.com/thesaurus/{}";
      linguee = "https://www.linguee.com.br/portugues-ingles/search?source=auto&query={}";
    };
    settings = {
      content.javascript.clipboard = "access-paste";
      scrolling.smooth = true;
      # Follow the desktop light/dark preference (darkman portal) instead of
      # the Stylix target's fixed value.
      colors.webpage.preferred_color_scheme = lib.mkForce "auto";
    };
  };
}
