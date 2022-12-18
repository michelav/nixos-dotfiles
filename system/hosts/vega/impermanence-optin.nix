{ config, lib, ... }:
let
  wipeScript = ''
    mkdir -p /btrfs
    mount -o subvol=/ /dev/disk/by-label/VEGA_BTRFS /btrfs
    if [ -e "/btrfs/root/dontwipe" ]; then
      echo "Not wiping root"
    else
      echo "Cleaning subvolume"
      btrfs subvolume list -o /btrfs/root | cut -f9 -d ' ' |
      while read subvolume; do
        btrfs subvolume delete "/btrfs/$subvolume"
      done && btrfs subvolume delete /btrfs/root
      echo "Restoring blank subvolume"
      btrfs subvolume snapshot /btrfs/root-blank /btrfs/root
    fi
    umount /btrfs
    rm -rf /btrfs
  '';
in {
  boot.initrd.postDeviceCommands = lib.mkBefore wipeScript;

  environment.persistence."/persist/vega" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/systemd"
      "/var/lib/docker/containers"
      "/var/lib/iwd"
      "/var/lib/jellyfin"
      "/var/cache/jellyfin"
      "/etc/NetworkManager/system-connections"
      "/srv"
    ];
    files = [
      # Vega ssh keys
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };
}
