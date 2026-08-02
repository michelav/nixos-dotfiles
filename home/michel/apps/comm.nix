{ pkgs, ... }:
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
}
