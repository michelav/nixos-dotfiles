{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    teams-for-linux
    discord
    slack
    element-desktop
    zoom-us
  ];

  home.persistence."/persist" = {
    directories = [
      ".config/Slack"
      ".config/discord"
      ".config/teams-for-linux"
    ];
  };

  # Teams for Linux reads these nested configuration options from its
  # environment, leaving its mutable config.json available to the app.
  home.sessionVariables = {
    APP__APPEARANCE__CSSLOCATION = "${config.xdg.configHome}/teams-for-linux/noctalia.css";
    APP__APPEARANCE__FOLLOWSYSTEMTHEME = "true";
  };
}
