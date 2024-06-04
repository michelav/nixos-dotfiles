{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.gamemode ];
  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      extraPackages = with pkgs; [ gamescope ];
    };
    gamemode = {
      enable = true;
    };
  };
}
