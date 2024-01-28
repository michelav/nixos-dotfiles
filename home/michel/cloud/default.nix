{ pkgs, ... }: {
  home.packages = [ pkgs.rclone ];
  imports = [ ./maestral.nix ];

  home.persistence."/persist/home/michel" = {
    allowOther = true;
    directories = [ "storages" ".config/maestral" ];
  };
}
