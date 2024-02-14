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
  waybar-main = (prev.waybar.overrideAttrs (_: {
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
  swaylock-effects-main = prev.swaylock-effects.overrideAttrs (_: {
    version = "20230812";
    src = prev.fetchFromGitHub {
      owner = "jirutka";
      repo = "swaylock-effects";
      rev = "7c5681ce96587ce3090c6698501faeccdfdc157d";
      sha256 = "sha256-09Kq90wIIF9lPjiY2anf9MSgi/EqeXKXW1mFmhxA/aM=";
    };
  });
  # TODO: Remove this as soon as wezterm version gets bumped in nixpkgs. Check https://github.com/wez/wezterm/issues/4483
  wezterm-main = prev.callPackage ./wezterm-main.nix {
    inherit (prev)
      stdenv rustPlatform lib fetchFromGitHub ncurses perl pkg-config python3
      fontconfig installShellFiles openssl libGL libxkbcommon wayland zlib
      CoreGraphics Cocoa Foundation System libiconv UserNotifications nixosTests
      runCommand vulkan-loader;
    inherit (prev.xorg)
      libX11 libxcb xcbutil xcbutilimage xcbutilkeysyms xcbutilwm;
  };

  # TODO: After flake lock update python-stem broke. Fix in 
  # https://github.com/torproject/stem/commit/9f1fa4ac53cf83a4cdd7155cc487212bf8bc08af .
  # Getting the version from 20240214 while Nixpkgs isn't updated
  python311 = prev.python311.override {
    packageOverrides = _: nPrev: {
      stem = nPrev.stem.overrideAttrs (_: {
        version = "20240214";
        src = prev.fetchFromGitHub {
          owner = "torproject";
          repo = "stem";
          rev = "9a9c7d4";
          hash = "sha256-Oc73Jx31SLzuhT9Iym5HHszKfflKZ+3aky5flXudvmI=";
        };
      });
    };
  };
  # nix-shell -p pythonPackages.my_stuff
  python311Packages = python311.pkgs;
}
