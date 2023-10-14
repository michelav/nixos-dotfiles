_: {
  xdg.configFile."containers/storage.conf".text = ''
    [storage]
    driver="btrfs"
  '';
}
