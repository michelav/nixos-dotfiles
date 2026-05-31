{ config, ... }:
{
  programs.imv =
    let
      palette = config.lib.stylix.colors;
    in
    {
      enable = true;
      settings = {
        options = {
          background = "#${palette.base00}";
        };
        aliases = {
          "<Shift+X>" = ''exec rm "$imv_current_file"; close'';
        };
      };
    };
}
