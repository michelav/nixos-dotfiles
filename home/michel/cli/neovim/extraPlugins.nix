{ pkgs, ... }: {
  nvim-catppuccin = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "nvim-catppuccin";
    version = "master";
    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "nvim";
      rev = "master";
      sha256 = "sha256-KSjPg/93YzprFyAFKOcGYZXlm2kjxMIYTZOeuu7OJvE=";
    };
  };
  nightfox-main = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "nightfox-main";
    version = "main";
    src = pkgs.fetchFromGitHub {
      owner = "EdenEast";
      repo = "nightfox.nvim";
      rev = "main";
      sha256 = "sha256-ShKC8fa12ArmAjaHIbRsFdDX+e4aXAQgGjizNWo+ooI=";
    };
  };
  onenord = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "onenord";
    version = "main";
    src = pkgs.fetchFromGitHub {
      owner = "rmehri01";
      repo = "onenord.nvim";
      rev = "main";
      sha256 = "sha256-vkgQNpr2pf+WegMdDJ3FAJk0tH2Q6G14Z4n1sGK9SN8=";
    };
  };
}
