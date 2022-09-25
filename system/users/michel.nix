{ pkgs, config, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.michel = {
    isNormalUser = true;
    password = "passwd";
    shell = pkgs.fish;
    extraGroups = [ "wheel" "video" "audio" ]
      ++ (if config.networking.networkmanager.enable then
        [ "networkmanager" ]
      else
        [ ])
      ++ (if config.virtualisation.docker.enable then [ "docker" ] else [ ]);
  };
}
