{ config, ... }:
let
  inherit (config) colorScheme userPrefs;
  inherit (colorScheme) palette;
in
{
  services.mako = {
    enable = true;
    settings = {
      # iconPath = "${config.gtk.iconTheme.package}/share/icons/${config.gtk.iconTheme.name}";
      font = "${userPrefs.fonts.regular.name} 10";
      padding = "10,20";
      anchor = "top-right";
      width = "400";
      height = "150";
      borderSize = "2";
      defaultTimeout = "5000";
      backgroundColor = "#${palette.base00}dd";
      borderColor = "#${palette.base03}dd";
      textColor = "#${palette.base05}dd";
      "urgency=low" = {
        default-timeout = "3000";
      };
      "urgency=high" = {
        default-timeout = "8000";
        border-color = "#${palette.base08}";
        text-color = "#${palette.base08}";
      };
      "mode=do-not-disturb" = {
        invisible = "1";
      };
    };
  };
}
