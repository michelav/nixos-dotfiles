_: {
  # Only state that no single module owns. Anything tied to one program is
  # declared next to that program; Home Manager merges the lists.
  home.persistence."/persist" = {
    directories = [
      "Desktop"
      "Documents"
      "Downloads"
      "Music"
      "Pictures"
      "Public"
      "Videos"
      "media"
      "repos"

      # No owning module: not installed through this configuration.
      ".config/github-copilot"
    ];
    files = [ ".config/sops/age/keys.txt" ];
  };
}
