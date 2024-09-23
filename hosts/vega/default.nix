{
  inputs,
  outputs,
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModule
    inputs.hyprland.nixosModules.default
    ../common/global
    ../common/users/michel.nix

    ./impermanence-optin.nix
    ./hardware-configuration.nix
    ../common/opts
    ../common/opts/nvidia.nix
    ../common/opts/power-mgmt.nix
    # INFO: Change the desktop option if u wanna another desktop / wm (gnome or hyprland for instance)
    ../common/opts/wayland.nix
  ];
  home-manager.extraSpecialArgs = {
    inherit inputs outputs;
  };

  networking.hostName = "vega";

  # Set your time zone.
  time.timeZone = "America/Fortaleza";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = lib.mkDefault "pt_BR.UTF-8";
    supportedLocales = lib.mkDefault [
      "pt_BR.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
    ];
  };
  console = {
    font = "${pkgs.terminus_font}/share/consolefonts/ter-116n.psf.gz";
    packages = with pkgs; [ terminus_font ];
    keyMap = "br-abnt2";
  };

  # Use the systemd-boot EFI boot loader.
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  hardware.enableRedistributableFirmware = true;
  hardware.bluetooth.enable = true;

  services = {
    openssh = {
      enable = true;
      settings.PermitRootLogin = "no";
      extraConfig = ''
        StreamLocalBindUnlink yes
      '';
      hostKeys = [
        {
          path = "/persist/vega/etc/ssh/ssh_host_rsa_key";
          type = "rsa";
        }
        {
          path = "/persist/vega/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
    };
    udisks2.enable = true;
    devmon.enable = true;

    logind =
      let
        sync_enabled = config.hardware.nvidia.prime.sync.enable;
      in
      {
        # If sync is on I may use it in docked mode
        lidSwitchExternalPower = if sync_enabled then "ignore" else "lock";
      };

    fstrim.enable = true;
    thermald.enable = true;

  };
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
