{ pkgs, ... }:
{
  home.packages = [ pkgs.zotero ];
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
