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
  ];

  home.persistence."/persist" = {
    directories = [
      ".cache/keepassxc"
      ".config/keepassxc"
      ".secrets/keepassxc"
    ];
  };
}
