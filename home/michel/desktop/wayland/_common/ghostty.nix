{
  pkgs,
  inputs,
  ...
}:
{
  programs.ghostty =
    let
      ghostty = inputs.ghostty.packages.${pkgs.system}.default;
    in
    {
      enable = true;
      package = ghostty;
      settings = {
        window-decoration = "none";
      };
    };
}
