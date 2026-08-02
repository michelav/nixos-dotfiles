{
  pkgs,
  inputs,
  ...
}:
{
  programs.ghostty =
    let
      system = pkgs.stdenv.hostPlatform.system;
      ghostty = inputs.ghostty.packages.${system}.default;
    in
    {
      enable = true;
      package = ghostty;
      settings = {
        window-decoration = "none";
      };
    };
}
