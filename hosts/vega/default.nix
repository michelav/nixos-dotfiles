# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in
{

  nix = {
    package = pkgs.nixFlakes; # or versioned attributes like nix_2_7
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };

  nixpkgs.overlays = [
    (self: super: {
      mpv = super.mpv-with-scripts.override {
        scripts = [ self.mpvScripts.mpris ];
      };
    })
  ];

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/gnome.nix
      ../../modules/virtual.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  networking.hostName = "vega"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time = {
   timeZone = "America/Fortaleza";
   # hardwareClockInLocalTime = true;
  };

  nixpkgs.config.allowUnfree = true;

  networking.useDHCP = false;
  networking.interfaces.enp7s0.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "pt_BR.UTF-8";
  console = {
    font = "${pkgs.terminus_font}/share/consolefonts/ter-116n.psf.gz";
    packages = with pkgs; [
      terminus_font
    ];
    keyMap = "br-abnt2";
  };

  xdg.portal.wlr.enable = true;
  hardware = {
    opengl.enable = true;
    bluetooth.enable = true;
    nvidia = {
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      prime = {
        offload.enable = true;
        # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
        intelBusId = "PCI:00:02:0";
        # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
        nvidiaBusId = "PCI:01:00:0";
      };
      powerManagement.finegrained = true;
    };
  };

  # Enable sound.
  security.rtkit.enable = true;
  services = {


    # transmission.enable = true;
    # transmission.settings.umask = 18;
    # transmission.settings.download-dir="/media/movies"; # SO Jellyfin may read video files

    jellyfin.enable = true;
    jellyfin.openFirewall = true;

    xserver.videoDrivers = [ "nvidia" ];

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_BAT="powersave";
        CPU_SCALING_GOVERNOR_ON_AC="performance";

        USB_DENYLIST="046d:c534";

        # The following prevents the battery from charging fully to
        # preserve lifetime. Run `tlp fullcharge` to temporarily force
        # full charge.
        # https://linrunner.de/tlp/faq/battery.html#how-to-choose-good-battery-charge-thresholds
        # START_CHARGE_THRESH_BAT0=40;
        #  STOP_CHARGE_THRESH_BAT0=50;

        # 100 being the maximum, limit the speed of my CPU to reduce
        # heat and increase battery usage:
        # CPU_MAX_PERF_ON_AC=100;
        # CPU_MAX_PERF_ON_BAT=60;
      };
  };

  fstrim.enable = true;
  thermald.enable = true;

  };

  programs = {
    fish.enable = true;
    dconf.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.michel = {
    isNormalUser = true;
    password = "passwd";
    shell = pkgs.fish;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "transmission" ];
  };

  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      corefonts
    ];
  };

   environment.pathsToLink = [ "/share/fish" ];

  environment.etc = {
	"wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
		bluez_monitor.properties = {
			["bluez5.enable-sbc-xq"] = true,
			["bluez5.enable-msbc"] = true,
			["bluez5.enable-hw-volume"] = true,
			["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
		}
	'';
  };

  hardware.enableRedistributableFirmware = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    # firefox
    git
    unzip
    nvidia-offload
    glxinfo
    vulkan-tools
    glmark2
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

