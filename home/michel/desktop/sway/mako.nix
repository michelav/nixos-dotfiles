{ config, ... }:
let inherit (config.colorScheme) colors;
in {
  programs.mako = {
    enable = true;
    # iconPath = "${config.gtk.iconTheme.package}/share/icons/${config.gtk.iconTheme.name}";
    font = "${config.fonts.regular.name} 10";
    padding = "10,20";
    anchor = "top-right";
    width = 400;
    height = 150;
    borderSize = 2;
    defaultTimeout = 5000;
    backgroundColor = "#${colors.base00}dd";
    borderColor = "#${colors.base03}dd";
    textColor = "#${colors.base05}dd";
    extraConfig = ''
      [urgency=low]
      default-timeout=3000
      [urgency=high]
      default-timeout=8000
      border-color=#${colors.base08}
      text-color=#${colors.base08}
      [mode=do-not-disturb]
      invisible=1
    '';
  };
}
