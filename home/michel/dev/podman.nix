{
  xdg.configFile."containers/storage.conf".text = ''
    [storage]
    driver="btrfs"
  '';

  home.persistence."/persist" = {
    directories = [ ".local/share/containers" ];
  };
}
