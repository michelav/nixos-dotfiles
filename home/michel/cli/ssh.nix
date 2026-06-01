{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.keychain ];

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        compression = true;
        ForwardAgent = false;
        AddKeysToAgent = "yes";

        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        HashKnownHosts = false;
        UserKnownHostsFile = "~/.ssh/known_hosts";

        ControlMaster = "no";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "no";
      };
      "github.com" = {
        identityFile = with config.home; "${homeDirectory}/.ssh/michelav_github";
      };
    };
  };
}
