{
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
      "secrets"
      ".mozilla/firefox"
      ".config/discord"
      ".config/Slack"
      ".config/qutebrowser/bookmarks"
      ".config/qutebrowser/greasemonkey"
      ".local/share/qutebrowser"
      ".dropbox-hm/.dropbox"
      ".dropbox-hm/.dropbox-dist"
      ".gnupg"
      ".ssh"
      ".aws"
      ".config/keepassxc"
      ".cache/keepassxc"
      ".config/spotify"
      ".cache/spotify"
      ".local/share/fish"
    ];
    files = [ ".config/sops/age/keys.txt" ];
  };
}