{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config = {
      global = {
        warn_timeout = "10s";
      };
    };
  };

  home.persistence."/persist" = {
    directories = [ ".local/share/direnv" ];
  };
}
