{pkgs, ...}:
{
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
}
