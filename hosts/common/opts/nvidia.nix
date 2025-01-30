{
  config,
  pkgs,
  lib,
  ...
}:
{
  nixpkgs.config = {
    packageOverrides = pkgs: { vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; }; };
  };
  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
        intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
      ];
      enable32Bit = true;
    };
    nvidia = {
      open = true;
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;

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
    glxinfo
    vulkan-tools
    glmark2
  ];

  # In the cases I'm not docked
  specialisation = {
    clamshell.configuration = {
      system.nixos.tags = [ "clamshell" ];
      hardware.nvidia = {
        prime = {
          sync.enable = lib.mkForce true;
          offload = {
            enable = lib.mkForce false;
            enableOffloadCmd = lib.mkForce false;
          };
        };
        powerManagement.finegrained = lib.mkForce false;
      };
    };
  };
}
