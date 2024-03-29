{ inputs, config, pkgs, ... }:
let
  inherit (inputs.hyprland.packages.${pkgs.system})
    hyprland xdg-desktop-portal-hyprland;
  hyprw-contrib = inputs.hyprland-contrib.packages.${pkgs.system};
  # currently, there is some friction between sway and gtk:
  # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
  # the suggested way to set gtk settings is with gsettings
  # for gsettings to work, we need to tell it where the schemas are
  # using the XDG_DATA_DIR environment variable
  # run at the end of sway config
  gtk-config = pkgs.writeTextFile {
    name = "gtk-config";
    destination = "/bin/gtk-config";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in with config.gtk; ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set "$gnome_schema" gtk-theme "${theme.name}"
      gsettings set "$gnome_schema" icon-theme "${iconTheme.name}"
      gsettings set "$gnome_schema" cursor-theme "${cursorTheme.name}"
      gsettings set "$gnome_schema" font-name "${font.name}"
    '';
  };
in {
  imports = [ inputs.hyprland.homeManagerModules.default ./wofi.nix ./eww ];
  home.packages =
    [ pkgs.swaybg pkgs.hyprpicker hyprw-contrib.grimblast gtk-config ];

  # Add this so we have a file chooser in the portal
  xdg.portal = {
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
      gnome.gnome-keyring
      xdg-desktop-portal-wlr
    ];
    configPackages = [ hyprland ];
    xdgOpenUsePortal = true;
  };
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    extraConfig = import ./config.nix { inherit config pkgs gtk-config; };
  };
}
