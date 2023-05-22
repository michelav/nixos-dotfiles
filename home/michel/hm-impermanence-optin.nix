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
      "Dropbox"
      "repos"
      ".mozilla/firefox"
      ".config/discord"
      ".config/Slack"
      ".config/qutebrowser/bookmarks"
      ".config/qutebrowser/greasemonkey"
      ".config/eww"
      ".local/share/qutebrowser"
      ".gnupg"
      ".ssh"
      ".aws"
      ".secrets/password-store"
      ".config/keepassxc"
      ".cache/keepassxc"
      ".cache/nix-index"
      ".secrets/keepassxc"
      ".config/spotify"
      ".cache/spotify"
      ".local/share/fish"
      ".local/share/devenv"
      ".local/share/direnv"

      # Keyrings
      ".local/share/keyrings"
    ];
    files = [ ".config/sops/age/keys.txt" ];
  };
}
