{ pkgs, ... }:
{
  home.packages = [ pkgs.seahorse ];
  home.persistence."/persist/home/michel" = {
    allowOther = true;
    directories = [
      {
        directory = ".local/share/keyrings";
        method = "symlink";
      }
    ];
  };
}
