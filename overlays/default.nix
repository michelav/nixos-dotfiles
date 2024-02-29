final: prev:
let
  inherit (prev.haskell.lib.compose) overrideCabal;
  inherit (prev.haskellPackages) hledger hledger-ui hledger-web;
  hledger-lib_131 = overrideCabal (_: {
    version = "1.31";
    revision = null;
    editedCabalFile = null;
    sha256 = "sha256-VKkOuZsMl10P02A8csygYo5HfGnhSM5VbHdaU5dkkJo=";
  }) prev.haskellPackages.hledger-lib;
in rec {
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
  # TODO: Remove as soon as nixpkgs gets the latest version
  hledger_131 = (overrideCabal (_: {
    version = "1.31";
    revision = null;
    editedCabalFile = null;
    sha256 = "sha256-AyIZiVi3cQUOt2b8T6g6o7isW5kHidEVeDo80xil/18=";
  }) hledger).override { hledger-lib = hledger-lib_131; };
  hledger-ui_131 = (overrideCabal (_: {
    version = "1.31";
    revision = null;
    editedCabalFile = null;
    sha256 = "sha256-y6ffAPWcOePZUBKrSRiHVISKMWRgsMEAfWeJXuejLpM=";
  }) hledger-ui).override {
    hledger-lib = hledger-lib_131;
    hledger = hledger_131;
  };
  hledger-web_131 = (overrideCabal (_: {
    version = "1.31";
    revision = null;
    editedCabalFile = null;
    sha256 = "sha256-IFGr37/ifc0YfX1UPZFJOg269IH+JRmpkRl3pldhrDw=";
  }) hledger-web).override {
    hledger-lib = hledger-lib_131;
    hledger = hledger_131;
  };
}
