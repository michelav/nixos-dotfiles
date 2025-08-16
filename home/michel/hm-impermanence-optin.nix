_: {
  home.persistence."/persist/home/michel" = {
    allowOther = true;
    directories = [
      "Desktop"
      "Downloads"
      "Music"
      "Pictures"
      "Documents"
      "Videos"
      "Public"
      "repos"
      ".mozilla/firefox"
      ".config/discord"
      ".config/Slack"
      ".config/qutebrowser/bookmarks"
      ".config/qutebrowser/greasemonkey"
      ".config/eww"
      ".config/teams-for-linux"
      ".local/share/qutebrowser"
      ".gnupg"
      ".ssh"
      ".secrets/password-store"
      ".config/keepassxc"
      ".cache/keepassxc"
      ".cache/nix-index"
      ".secrets/keepassxc"
      ".config/spotify"
      ".cache/spotify"
      ".local/share/fish"
      ".local/share/devenv"
      ".local/share/plex"
      ".local/share/direnv"
      ".local/state/lazygit"
      {
        directory = ".local/share/containers";
        method = "symlink";
      }
    ];
    files = [ ".config/sops/age/keys.txt" ];
  };
}
