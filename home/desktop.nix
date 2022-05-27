{ config, pkgs, ... }:
/*
* Must config:
* terminal
* shell
* base apps
*/
{
  imports = [
    ./neovim
    ./fish.nix
    ./theme.nix
    ./vscode.nix
  ];

  home.sessionVariables.BROWSER = "firefox";

  home.packages = with pkgs; [
    transmission-gtk
  ];

  programs = {
    java.enable = true;
    bat.enable = true;
    foot = {
      enable = true;
      server.enable = true;
    };
    alacritty.enable = true;
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
    firefox = {
      enable = true;

      package = pkgs.firefox-wayland.override {
        cfg = {
          enableGnomeExtensions = true;
        };
      };
    };
    fzf.enable = true;
    fzf.enableFishIntegration = true;
  };

  services = {
    easyeffects.enable = true;
    dropbox.enable = true;
  };
  xdg.configFile."alacritty/alacritty.yml".source = ../config/alacritty.yml;
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

 };
}
