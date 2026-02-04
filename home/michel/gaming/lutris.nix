{ pkgs, ... }:
{
  home.packages = [ pkgs.lutris ];
  home.persistence = {
    "/persist" = {
      directories = [
        "Games/Lutris"
        ".config/lutris"
        ".local/share/lutris"
      ];
    };
  };
}
