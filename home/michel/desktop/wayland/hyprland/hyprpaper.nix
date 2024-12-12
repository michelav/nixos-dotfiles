_: {
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        "~/Pictures/wallpapers/nixos_1920x1080.jpg"
        "~/Pictures/wallpapers/nixos_3440x1440_v2.jpg"
      ];
      wallpaper = [
        "DP-1, ~/Pictures/wallpapers/nixos_3440x1440_v2.jpg"
        "eDP-1, ~/Pictures/wallpapers/nixos_1920x1080.jpg"
      ];
    };
  };
  # Systemd Unit provided is targeted to start before WAYLAND_DISPLAY
  # is defined. AJusting the precedence in order to the Unit works.
  # See: https://github.com/Vladimir-csp/uwsm/issues/40 .
  # TODO: Remove this line as soon as it gets fixed.
  systemd.user.services.hyprpaper.Unit.After = [ "graphical-session.target" ];
}
