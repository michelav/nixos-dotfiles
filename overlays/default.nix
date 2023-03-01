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

  #  TODO: Remove after https://github.com/NixOS/nixpkgs/pull/218753 goes to Unstable
  # https://nixpk.gs/pr-tracker.html?pr=218753
  python310 = prev.python310.override {
    packageOverrides = _: iPrev: {
      adblock = iPrev.adblock.overrideAttrs (oldAttrs: {
        patches = (oldAttrs.patches or [ ]) ++ [
          # https://github.com/ArniDagur/python-adblock/pull/91
          (prev.fetchpatch {
            name = "pep-621-compat.patch";
            url =
              "https://github.com/ArniDagur/python-adblock/commit/2a8716e0723b60390f0aefd0e05f40ba598ac73f.patch";
            hash = "sha256-n9+LDs0no66OdNZxw3aU57ngWrAbmm6hx4qIuxXoatM=";
          })
        ];
      });
    };
  };
  python310Packages = python310.pkgs;
}
