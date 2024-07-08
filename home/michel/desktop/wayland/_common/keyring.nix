{ pkgs, ... }:
{
  home.packages = [ pkgs.seahorse ];
  services.gnome-keyring = {
    enable = true;
    components = [ "secrets" ];
  };

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
