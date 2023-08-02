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
  };
  iamlive = prev.callPackage ../packages/iamlive {
    inherit (prev) lib fetchFromGitHub buildGoModule;
  };
}
