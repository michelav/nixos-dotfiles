_: {
  home.persistence."/persist" = {
    directories = [
      "Desktop"
      "Downloads"
      "Music"
      "Pictures"
      "Documents"
      "Videos"
      "Public"
      "repos"
      ".config/discord"
      ".config/Slack"
      ".config/eww"
      ".config/github-copilot"
      ".config/teams-for-linux"
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
      ".local/share/containers"
      "media"
    ];
    files = [ ".config/sops/age/keys.txt" ];
  };
}
