{ pkgs, ... }:
{
  # GUI applications. Nothing here is tied to a specific compositor;
  # compositor-coupled configuration lives in ../desktop/wayland.
  imports = [
    ./bnb.nix
    ./browsers.nix
    ./comm.nix
    ./ghostty.nix
    ./images.nix
    ./nemo.nix
    ./virt-manager.nix
    ./wezterm.nix
    ./zathura.nix
  ];

  home.packages = with pkgs; [
    keepassxc
    transmission_4-gtk
    fractal
    drawio
    obs-studio
    kdePackages.kdenlive
    shotcut
    pympress
  ];

  home.persistence."/persist" = {
    directories = [
      ".cache/keepassxc"
      ".config/keepassxc"
      ".secrets/keepassxc"
    ];
  };

  # Default apps
  xdg.mimeApps = {
    defaultApplications = {
    };
  };
  xdg.mimeApps.defaultApplications = {
    # Web
    "text/html" = [
      "firefox.desktop"
      "org.qutebrowser.qutebrowser.desktop"
    ];
    "text/xml" = [
      "firefox.desktop"
      "org.qutebrowser.qutebrowser.desktop"
    ];
    "x-scheme-handler/http" = [
      "firefox.desktop"
      "org.qutebrowser.qutebrowser.desktop"
    ];
    "x-scheme-handler/https" = [
      "firefox.desktop"
      "org.qutebrowser.qutebrowser.desktop"
    ];
    "x-scheme-handler/chrome" = [ "firefox.desktop" ];
    "x-scheme-handler/qute" = [ "org.qutebrowser.qutebrowser.desktop" ];

    # File explorer
    "inode/directory" = [ "nemo.desktop" ];
    "application/x-gnome-saved-search" = [ "nemo.desktop" ];

    # Teams
    "x-scheme-handler/msteams" = [ "teams-for-linux.desktop" ];
  };
}
