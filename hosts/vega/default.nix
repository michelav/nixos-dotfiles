{
  inputs,
  outputs,
  pkgs,
  lib,
  config,
  ...
}:
let
  hyprland = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  hyprlandUWSMEntry = pkgs.writeText "hyprland-uwsm.desktop" ''
    [Desktop Entry]
    Name=Hyprland (uwsm-managed)
    Comment=An intelligent dynamic tiling Wayland compositor
    Exec=uwsm start -e -D Hyprland ${hyprland}/share/wayland-sessions/hyprland.desktop
    TryExec=uwsm
    DesktopNames=Hyprland
    Type=Application
  '';
  hyprlandSession = lib.makeOverridable (
    _:
    pkgs.symlinkJoin {
      name = "hyprland-${hyprland.version}-uwsm-session";
      version = hyprland.version;
      paths = [ hyprland ];
      passthru.providedSessions = [ "hyprland-uwsm" ];
      postBuild = ''
        rm "$out/share/wayland-sessions/hyprland.desktop"
        rm "$out/share/wayland-sessions/hyprland-uwsm.desktop"
        ln -s ${hyprlandUWSMEntry} "$out/share/wayland-sessions/hyprland-uwsm.desktop"
      '';
    }
  ) { };
in
{
  imports = [
    # Include the results of the hardware scan.
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModules.impermanence
    inputs.hyprland.nixosModules.default
    inputs.umbriel.nixosModules.default
    ../common/global
    ../common/users/michel.nix

    ./impermanence-optin.nix
    ./hardware-configuration.nix
    ./storage-health.nix

    # Feature modules this host opts into. Everything vega enables is listed
    # here; `hosts/common/opts` is a menu, not a bundle.
    ../common/opts/media.nix
    ../common/opts/monitoring.nix
    ../common/opts/networking.nix
    ../common/opts/nvidia.nix
    ../common/opts/pipewire.nix
    ../common/opts/power-mgmt.nix
    # INFO: Change the desktop option if u wanna another desktop / wm (gnome or hyprland for instance)
    ../common/opts/wayland.nix
  ];
  home-manager.extraSpecialArgs = {
    inherit inputs outputs;
  };

  networking.hostName = "vega";

  programs.umbriel.enable = true;
  programs.hyprland.package = lib.mkForce hyprlandSession;
  services.displayManager.noctalia-greeter = {
    enable = true;
    settings = {
      user.default = "michel";
      keyboard = {
        layout = "us,br";
        variant = "intl,";
        options = "grp:alt_altgr_toggle";
      };
    };
  };
  # Seed the first choice without overriding the greeter's remembered session.
  systemd.tmpfiles.settings."10-noctalia-greeter"."/var/lib/noctalia-greeter/sync.toml".f = {
    user = "greeter";
    group = "greeter";
    mode = "0644";
    argument = ''
      [session]
      last = "Hyprland (uwsm-managed)"
    '';
  };
  security.pam.services.greetd.enableGnomeKeyring = true;

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
        settings.Login.HandleLidSwitchExternalPower = if sync_enabled then "ignore" else "lock";
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
