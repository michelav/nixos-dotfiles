{ pkgs, ... }:
{
  home.packages = [ pkgs.seahorse ];
  home.persistence."/persist" = {
    directories = [
      {
        directory = ".local/share/keyrings";
        mode = "0700";
      }
    ];
  };
}
