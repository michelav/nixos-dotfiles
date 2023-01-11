final: prev: {
  vimPlugins = prev.vimPlugins // {
    nvim-treesitter-full = (prev.vimPlugins.nvim-treesitter.withPlugins
      (_: final.tree-sitter.allGrammars)).overrideAttrs (_: rec {
        version = "2022-08-29";
        pname = "nvim-treesitter-full";
        src = final.fetchFromGitHub {
          owner = "nvim-treesitter";
          repo = "nvim-treesitter";
          rev = "master";
          sha256 = "sha256-ALifcM+Fd05cKVgUDROTYi0AE7V19aap2R4Hn9HNROI=";
        };
      });
  };
  iamlive = prev.callPackage ../packages/iamlive {
    inherit (prev) lib fetchFromGitHub buildGoModule;
  };
  spotify-nss-latest = prev.spotify.override { nss = prev.nss_latest; };
  # TODO: Remove this patch after current version of Sway-effects starts working with sway 1.8.
  swaylock-effects = prev.swaylock-effects.overrideAttrs (oldAttrs: {
    patches = (oldAttrs.patches or [ ]) ++ [ ./swaylock-effects.diff ];
  });

}
