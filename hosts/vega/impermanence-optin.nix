{ lib, pkgs, ... }:
let
  cryptService = "systemd-cryptsetup@vega_crypt.service";
  wipeScript = ''
    mkdir -p /btrfs
    mount -o subvol=/ /dev/mapper/vega_crypt /btrfs
    if [ -e "/btrfs/root/dontwipe" ]; then
      echo "rollback-root: Not wiping root"
    else
      echo "rollback-root: Cleaning subvolume"
      btrfs subvolume list -o /btrfs/root | cut -f9 -d ' ' |
      while read subvolume; do
        echo "rollback-root: deleting /btrfs/$subvolume"
        btrfs subvolume delete "/btrfs/$subvolume"
      done && echo "rollback-root: Deleting root subvolume" && btrfs subvolume delete /btrfs/root
      echo "rollback-root: Restoring blank subvolume"
      btrfs subvolume snapshot /btrfs/root-blank /btrfs/root
    fi
    umount /btrfs
    rm -rf /btrfs
  '';
in
{
  boot.initrd.systemd.services.rollback-root = {
    description = "Rollback Btrfs root subvolume";
    wantedBy = [ "initrd.target" ];
    # requiredBy = [ "sysroot.mount" ];
    before = [ "sysroot.mount" ];
    after = [
      cryptService
    ];

    unitConfig.DefaultDependencies = "no";

    serviceConfig = {
      Type = "oneshot";
    };

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
