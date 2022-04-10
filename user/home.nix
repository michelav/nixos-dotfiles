{ inputs, config, pkgs, ... }:

{

  imports = [ ./sway.nix ./waybar.nix inputs.nix-colors.homeManagerModule ];

  colorscheme = inputs.nix-colors.colorSchemes.dracula;

  home = {
   
   username = "michel";
   homeDirectory = "/home/michel";
   sessionVariables = {
      # environment variables
      BROWSER = "brave";
      EDITOR = "nvim";
      REMINDERS = "${config.home.homeDirectory}/.reminders";
      # wayland
      XDG_DESKTOP_SESSION = "sway";
      XDG_SESSION_TYPE = "wayland";
   };
   
   packages = with pkgs; [
       keepassxc
       bemenu
       libnotify
       fuzzel
       swayidle
       swaylock
       wl-clipboard
       grim
       slurp
       neofetch
       jq
   ];
 
   
 };

  programs = {
    brave.enable = true;
    fish.enable = true;
    git = {
      enable = true;
      userName  = "michelav";
      userEmail = "michel.vasconcelos@gmail.com";
    };
    vscode = {
      enable = true;
      mutableExtensionsDir = false;
      extensions = with pkgs.vscode-extensions; [
        bbenoist.nix
      ]; 
    };
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = if config.colorscheme.kind == "light" then "Papirus" else "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "gruvbox-dark";
      package = pkgs.gruvbox-dark-gtk;
    };
    font = {
      name = "JetBrains Mono";
      size = 10;
    };
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
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
