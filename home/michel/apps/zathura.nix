{ config, ... }:
let
  fonts = config.stylix.fonts;
in
{
  stylix.targets.zathura.enable = true;

  programs.zathura = {
    enable = true;
    options = {
      selection-clipboard = "clipboard";
      font = "${fonts.sansSerif.name} 12";
      recolor = true;
    };
  };
}
