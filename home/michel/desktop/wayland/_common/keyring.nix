{ pkgs, ... }: {
  home.packages = [ pkgs.gnome.seahorse ];
  services.gnome-keyring = {
    enable = true;
    components = [ "secrets" ];
  };

  home.persistence."/persist/home/michel" = {
    allowOther = true;
    directories = [{
      directory = ".local/share/keyrings";
      method = "symlink";
    }];
  };
}
