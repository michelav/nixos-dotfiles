{
  environment.persistence."/persist/vega" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/systemd"
      "/var/lib/docker/containers"
      "/var/lib/iwd"
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
