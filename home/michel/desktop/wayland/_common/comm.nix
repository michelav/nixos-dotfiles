{ pkgs, ... }: {
  home.packages = with pkgs; [
    teams-for-linux
    discord
    slack
    element-desktop
    zoom-us
  ];
}
