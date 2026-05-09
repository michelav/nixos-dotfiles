{ pkgs }:

let
  dictionaries = with pkgs.hunspellDicts; [
    {
      spelllang = "pt";
      spellfile = "pt";
      aliases = [
        "pt"
        "br"
        "pt_br"
      ];
      dict = pt_BR;
    }

    {
      spelllang = "en_us";
      spellfile = "en";
      aliases = [
        "en"
        "us"
      ];
      dict = en_US;
    }

    {
      spelllang = "en_gb";
      spellfile = "en";
      aliases = [
        "gb"
        "uk"
      ];
      dict = en_GB-ise;
    }

    # French temporarily disabled.
    # {
    #   spelllang = "fr";
    #   spellfile = "fr";
    #   aliases = [ "fr" ];
    #   dict = fr-classique;
    # }
  ];

  packages = map (d: d.dict) dictionaries;

  env = pkgs.symlinkJoin {
    name = "hunspell-dictionaries";
    paths = packages;
  };
in
{
  inherit dictionaries packages env;

  dictionaryPath = "${env}/share/hunspell";
}
