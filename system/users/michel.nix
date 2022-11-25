{ pkgs, config, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  sops.secrets.michel-passwd = {
    sopsFile = ../secrets/vega.yaml;
    neededForUsers = true;
  };
  users.mutableUsers = false;
  users.users.michel = {
    isNormalUser = true;
    passwordFile = config.sops.secrets.michel-passwd.path;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "video" "audio" ]
      ++ (if config.networking.networkmanager.enable then
      [ "networkmanager" ]
    else
      [ ])
      ++ (if config.virtualisation.docker.enable then [ "docker" ] else [ ]);
  };
}
