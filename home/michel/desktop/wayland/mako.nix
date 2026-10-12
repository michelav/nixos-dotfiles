{
  stylix.targets.mako.enable = true;

  services.mako = {
    enable = true;
    settings = {
      # iconPath = "${config.gtk.iconTheme.package}/share/icons/${config.gtk.iconTheme.name}";
      padding = "10,20";
      anchor = "top-right";
      width = "400";
      height = "150";
      borderSize = "2";
      defaultTimeout = "5000";
      "urgency=low" = {
        default-timeout = "3000";
      };
      "urgency=high" = {
        default-timeout = "8000";
      };
      "mode=do-not-disturb" = {
        invisible = "1";
      };
    };
  };
}
