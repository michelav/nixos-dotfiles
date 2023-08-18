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
  waybar-main = (prev.waybar-hyprland.overrideAttrs (_: {
    version = "0.9.22_20230817";
    src = prev.fetchFromGitHub {
      owner = "Alexays";
      repo = "Waybar";
      rev = "master";
      hash = "sha256-cNwh1LR0ZyF80anyAOMWW8UPebY2DKFH2Cr+5isLjAM=";
    };
  })).override {
    withMediaPlayer = true;
    hyprlandSupport = true;
  };
}
