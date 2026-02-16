{
  config,
  pkgs,
  lib,
  ...
}:
{
  nixpkgs.config = {
    packageOverrides = pkgs: {
      intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
    };
  };
  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver
        libva-vdpau-driver
        libvdpau-va-gl
        intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
      ];
      enable32Bit = true;
    };
    nvidia = {
      open = true;
      modesetting.enable = true;
      # FIXME: Remove this patch when the kernel 6.19 is released and the nvidia package is updated
      # https://github.com/NixOS/nixpkgs/issues/489947
      # START Patch for kernel 6.19 2026-02-15
      package =
        let
          base = config.boot.kernelPackages.nvidiaPackages.latest;
          cachyos-nvidia-patch = pkgs.fetchpatch {
            url = "https://raw.githubusercontent.com/CachyOS/CachyOS-PKGBUILDS/master/nvidia/nvidia-utils/kernel-6.19.patch";
            sha256 = "sha256-YuJjSUXE6jYSuZySYGnWSNG5sfVei7vvxDcHx3K+IN4=";
          };
          driverAttr = if config.hardware.nvidia.open then "open" else "bin";
        in
        base
        // {
          ${driverAttr} = base.${driverAttr}.overrideAttrs (oldAttrs: {
            patches = (oldAttrs.patches or [ ]) ++ [ cachyos-nvidia-patch ];
          });
        };
      # END Patch for kernel 6.19
      # package = config.boot.kernelPackages.nvidiaPackages.latest;

      /*
        INFO: These configs work well for vega, but I should change it if I get
        more PCs with NVidia cards
      */
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
        intelBusId = "PCI:00:02:0";
        # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
        nvidiaBusId = "PCI:01:00:0";
      };
      powerManagement.finegrained = true;
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  environment.systemPackages = with pkgs; [
    mesa-demos
    vulkan-tools
    glmark2
  ];
}
