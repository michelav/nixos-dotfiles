final: prev: rec {
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
  greetd = prev.greetd // {
    regreet = prev.greetd.regreet.overrideAttrs (old: rec {
      version = "2023-04-05";
      src = final.fetchFromGitHub {
        owner = "rharish101";
        repo = "ReGreet";
        rev = "27f21a7642f2bdda625a0372e777b87dab23499c";
        hash = "sha256-fSmjPEXzcyGIahPtF2BagUL4rncDqrK4h1wsUu0vd+A=";
      };

      cargoDeps = old.cargoDeps.overrideAttrs (_: {
        inherit src;
        outputHash = "sha256-C7RwnXqnoLeFdA7Yd/o5NtTI+UR9qwn0NrV2zxF7cIg=";
      });

    });
  };
}
