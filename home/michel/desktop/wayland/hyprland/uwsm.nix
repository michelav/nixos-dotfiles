{
  config,
  osConfig,
  ...
}:
{
  # Using UWSM (https://wiki.hyprland.org/Useful-Utilities/Systemd-start/)
  wayland.windowManager.hyprland.systemd.enable = false;

  # uwsm users should use theses files do place variables
  # See https://wiki.hyprland.org/Configuring/Environment-variables/ .
  xdg.configFile."uwsm/env".text =
    let
      cursor_size = "${toString config.home.pointerCursor.size}";
    in
    ''
      export XDG_CURRENT_DESKTOP=Hyprland
      export XDG_SESSION_DESKTOP=
      export GTK_THEME=${config.gtk.theme.name}
      export HYPRCURSOR_THEME=Bibata-modern
      export HYPRCURSOR_SIZE=${cursor_size}
    ''
    + (
      if osConfig.hardware.nvidia.prime.offload.enable then
        ''
          export LIBVA_DRIVER_NAME=nvidia
          export GBM_BACKEND=nvidia-drm
          export __GLX_VENDOR_LIBRARY_NAME=nvidia
        ''
      else
        ""
    );
}
