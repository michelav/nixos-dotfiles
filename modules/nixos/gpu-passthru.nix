{ config, lib, ... }:
let
  inherit (lib) types mkOption mkEnableOption mkIf;
  cfg = config.gpuPassthru;
in {
  options.gpuPassthru = {
    enable = mkEnableOption "enable gpu passthru";
    iommu-mode = mkOption {
      type = with types; enum [ "amd_iommu" "intel_iommu" ];
      default = "intel_iommu";
      description = ''
        Whether to use AMD or Intel iommu.
      '';
    };
    devices = mkOption {
      type = with types; listOf str;
      default = [ ];
      description = ''
        A list of PCI IDs in the form "vendor:product" where vendor and product
        are 4-digit hex values.
      '';
    };
    enableAcs = mkEnableOption "enable acs patch with zen kernel";
  };
  config = mkIf cfg.enable {
    hardware.opengl.enable = true;
    boot = {
      kernelParams = [
        # enable IOMMU
        "${cfg.iommu-mode}=on"
        "iommu=pt"
        "vfio_iommu_type1.allow_unsafe_interrupts=1"
      ] ++ lib.optional cfg.enableAcs
        "pcie_acs_override=downstream,multifunction" ++
        # isolate the GPU
        lib.optional (builtins.length cfg.devices > 0)
        ("vfio-pci.ids=" + lib.concatStringsSep "," cfg.devices);

      initrd.kernelModules =
        lib.mkBefore [ "vfio_pci" "vfio" "vfio_iommu_type1" ];
    };
  };
}
