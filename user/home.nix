{ inputs, config, pkgs, ... }:
{

  imports = [ ./sway.nix ./waybar.nix inputs.nix-colors.homeManagerModule ];

  colorscheme = inputs.nix-colors.colorSchemes.catppuccin;

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
       libnotify
       fuzzel
       swayidle
       swaylock-effects
       wl-clipboard
       grim
       slurp
       neofetch
        jq
       mako
       wofi
       pavucontrol
       spotify
       playerctl
   ];


 };

  programs = {
    mpv.enable = true;
    fish.enable = true;
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
    vscode = {
      enable = true;
      # package = pkgs.vscode-insiders;
      mutableExtensionsDir = false;

      userSettings = {
        "editor.renderWhitespace" = "all";
        "editor.rulers" = [ 80 120 ];
        "editor.tabSize" = 2;
        "editor.fontLigatures" = true;
        "workbench.fontAliasing" = "antialiased";
        "workbench.colorTheme" = "Catppuccin";
        "files.trimTrailingWhitespace" = true;
        "workbench.iconTheme" = "vscode-icons";
      };

      extensions = with pkgs.vscode-extensions; [
        bbenoist.nix
        eamodio.gitlens
        ms-python.python
        ms-vscode-remote.remote-ssh
        Catppuccin.catppuccin-vsc
      ];
    };
    brave = {
      enable = true;
      commandLineArgs = [ "--disable-gpu" ];
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
      name = "JetBrainsMono Nerd Font";
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

    # configFile."Code/code-flags.conf".text = "--disable-gpu";
    # configFile."electron-flags.conf".text = "--disable-gpu";
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
