{ pkgs, ... }:
{
  # FIXME: Comment out after fixing zotero in nixpkgs
  # https://github.com/NixOS/nixpkgs/issues/568692
  # home.packages = [ pkgs.zotero ];
  programs.obsidian = {
    enable = true;
    cli.enable = true;
  };
  home.persistence."/persist" = {
    directories = [
      ".zotero"
      ".config/obsidian"
    ];
  };
}
