{ pkgs, ... }:
let
  cryptService = "systemd-cryptsetup@vega_crypt.service";
  wipeScript = ''
    set -euo pipefail

    mkdir -p /btrfs
    mount -t btrfs -o subvol=/ /dev/mapper/vega_crypt /btrfs

    if [ -e "/btrfs/root/dontwipe" ]; then
      echo "rollback-root: not wiping root because /btrfs/root/dontwipe exists"
    else
      echo "rollback-root: deleting nested subvolumes under /btrfs/root"

      btrfs subvolume list -o /btrfs/root |
      tac |
      while IFS= read -r line; do
        subvolume="''${line#* path }"

        if [ -n "$subvolume" ] && [ "$subvolume" != "$line" ]; then
          echo "rollback-root: deleting /btrfs/$subvolume"
          btrfs subvolume delete "/btrfs/$subvolume"
        fi
      done

      echo "rollback-root: deleting /btrfs/root"
      btrfs subvolume delete /btrfs/root

      echo "rollback-root: restoring /btrfs/root from /btrfs/root-blank"
      btrfs subvolume snapshot /btrfs/root-blank /btrfs/root
    fi

    sync
    umount /btrfs
    rmdir /btrfs
  '';
in
{
  boot.initrd.systemd.services.rollback-root = {
    description = "Rollback Btrfs root subvolume";
    wantedBy = [ "initrd.target" ];
    before = [ "sysroot.mount" ];
    after = [
      cryptService
    ];

    unitConfig.DefaultDependencies = "no";

    serviceConfig = {
      Type = "oneshot";
      StandardOutput = "journal+console";
      StandardError = "journal+console";
    };

    path = [
      pkgs.btrfs-progs
      pkgs.coreutils
      pkgs.util-linux
    ];

    script = wipeScript;
  };

  environment.persistence."/persist/vega" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/systemd"
      "/var/lib/iwd"
      "/var/lib/plex"
      # "/var/lib/jellyfin"
      # "/var/cache/jellyfin"
      "/var/lib/nixos" # keeping users between boots
      "/var/lib/libvirt/images"
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
