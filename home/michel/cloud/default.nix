{ pkgs, ... }:
{
  home.packages = [ pkgs.rclone ];
  imports = [
    ./maestral.nix
    ./onedrive.nix
  ];

  home.persistence."/persist" = {
    directories = [
      "storages"
      ".config/maestral"
      ".config/rclone"
    ];
  };
}
