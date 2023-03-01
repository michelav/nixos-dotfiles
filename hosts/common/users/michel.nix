{ pkgs, config, ... }: {
  sops.secrets.michel-passwd = {
    sopsFile = ../secrets/vega.yaml;
    neededForUsers = true;
  };
  # users.mutableUsers = false;
  users.users.michel = {
    isNormalUser = true;
    # password = "pass";
    passwordFile = config.sops.secrets.michel-passwd.path;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "video" "audio" "libvirtd" ]
      ++ (if config.networking.networkmanager.enable then
        [ "networkmanager" ]
      else
        [ ])
      ++ (if config.virtualisation.docker.enable then [ "docker" ] else [ ])
      ++ (if config.virtualisation.libvirtd.enable then
        [ "libvirtd" ]
      else
        [ ]);
  };
}
