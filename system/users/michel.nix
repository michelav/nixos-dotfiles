{ pkgs, ... }:  { # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.michel = {
    isNormalUser = true;
    password = "passwd";
    shell = pkgs.fish;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "transmission" ];
  };
}
