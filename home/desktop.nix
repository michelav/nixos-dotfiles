{ config, pkgs, ... }:
/*
* Must config:
* terminal
* shell
* base apps
*/
{
  imports = [
    ./neovim.nix
    ./fish.nix
    ./theme.nix
    ./vscode.nix
  ];

  home.packages = with pkgs; [
    neofetch
    jq
  ];

  home.sessionVariables.BROWSER = "brave";

  programs = {
    mpv.enable = true;
    git = {
      enable = true;
      userName  = "michelav";
      userEmail = "michel.vasconcelos@gmail.com";
      delta = {
         enable = true;
         options = {
            navigate = true;
            # line-numbers = true;
            syntax-theme = "Dracula";
            features = "side-by-side line-numbers decorations";
            plus-style = "syntax #003800";
            minus-style = "syntax #3f0001";
            decorations = {
              commit-decoration-style = "bold yellow box ul";
              file-style = "bold yellow ul";
              file-decoration-style = "none";
              hunk-header-decoration-style = "cyan box ul";
            };
            line-numbers = {
              line-numbers-left-style = "cyan";
              line-numbers-right-style = "cyan";
              line-numbers-minus-style = 124;
              line-numbers-plus-style = 28;
            };
         };
      };
    };
    brave.enable = true;
  };

  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps.enable = false;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      publicShare = "${config.home.homeDirectory}/Public";
      templates = "${config.home.homeDirectory}/Templates";
      videos = "${config.home.homeDirectory}/Videos";
    };
    systemDirs.data = [ "/usr/share" "/usr/local/share" ];

    # configFile."Code/code-flags.conf".text = "--disable-gpu";
    # configFile."electron-flags.conf".text = "--disable-gpu";
  };



}