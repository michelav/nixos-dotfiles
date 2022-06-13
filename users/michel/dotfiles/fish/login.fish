for env_var in (gnome-keyring-daemon --start)
  set -x (echo $env_var | string split "=")
end
if test (tty) = /dev/tty1
  set -l CARD $(udevadm info -q property --value -n /dev/dri/by-path/pci-0000:00:02.0-card | grep /dev/dri/card)
  WLR_DRM_DEVICES=$CARD sway -V
end
