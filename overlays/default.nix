final: prev: {
  vimPlugins = prev.vimPlugins // {
    cmp-hledger = final.vimUtils.buildVimPlugin rec {
      pname = "cmp-hledger";
      version = "main";
      src = final.fetchFromGitHub {
        owner = "kirasok";
        repo = "cmp-hledger";
        rev = "${version}";
        sha256 = "sha256-5P6PsCop8wFdFkCPpShAoCj1ygryOo4VQUZQn+0CNdo=";
      };
    };
    # TODO: Remove overlay and use default package after the fix is incorporated into nixpkgs
    none-ls-nvim-20250503 = final.vimUtils.buildVimPlugin {
      pname = "none-ls.nvim";
      version = "2025-05-03";
      src = final.fetchFromGitHub {
        owner = "nvimtools";
        repo = "none-ls.nvim";
        rev = "7c493a266a6b1ed419f8a2e431651bc15b10df27";
        sha256 = "sha256-rUNZLkmcbkkWnlY0A8UpL+0zPAs3FYP8mKkL0k3Bpc4=";
      };
      meta.homepage = "https://github.com/nvimtools/none-ls.nvim/";
      meta.hydraPlatforms = [ ];
    };
  };
  iamlive = prev.callPackage ../packages/iamlive {
    inherit (prev) lib fetchFromGitHub buildGoModule;
  };
}
