{ pkgs, ... }: {
  home.packages = [ pkgs.rclone ];
  imports = [ ./maestral.nix ./onedrive.nix ];

  home.persistence."/persist/home/michel" = {
    allowOther = true;
    directories = [
      {
        directory = "storages";
        method = "symlink";
      }
      ".config/maestral"
      ".config/rclone"
    ];
  };
}
