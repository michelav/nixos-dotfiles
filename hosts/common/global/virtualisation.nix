{ pkgs, ... }:
{
  imports = [
    ./docker.nix
    # ./podman.nix
  ];

  # Install necessary packages
  environment.systemPackages = with pkgs; [
    libguestfs
    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    win-virtio
    win-spice
  ];

  # Manage the virtualisation services
  hardware.nvidia-container-toolkit.enable = true;
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
      };
    };
    vmVariantWithBootLoader = {
      # To test config in VMs
      virtualisation = {
        memorySize = 4096;
        cores = 4;
      };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;

}
