if test (tty) = /dev/tty1
  eval $(keychain --eval --agents ssh)
  set -l CARD $(udevadm info -q property --value -n /dev/dri/by-path/pci-0000:00:02.0-card | grep /dev/dri/card)
  WLR_DRM_DEVICES=$CARD sway -V
end
