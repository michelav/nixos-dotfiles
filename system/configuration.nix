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

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp7s0.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "pt_BR.UTF-8";
  console = {
    keyMap = "br-abnt2";
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    extraPackages = with pkgs; [
      mako # notification daemon
      alacritty # Alacritty is the default terminal in the config
      wofi # Dmenu is the default in the config but i recommend wofi since its wayland native
    ];
  };
  xdg.portal.wlr.enable = true;
  hardware = {
    opengl.enable = true;
    bluetooth.enable = true;
    nvidia = {
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      prime = {
        offload.enable = true;
        # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
        intelBusId = "PCI:00:02:0";
        # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
        nvidiaBusId = "PCI:01:00:0";
      };
      powerManagement.enable = false;
    };
  };
  
  security.pam.services.swaylock = {};
  # Enable sound.
  security.rtkit.enable = true;
  services = {
    xserver.videoDrivers = [ "nvidia" ];

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
    
      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
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

};

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  programs = {
    zsh.enable = true;
    fish.enable = true;
    light.enable = true;
  }; 

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.michel = {
    isNormalUser = true;
    password = "passwd";
    shell = pkgs.fish;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ]; 
  };
   
   fonts.fonts = with pkgs; [
      font-awesome
      fira-code
      (nerdfonts.override { fonts = [ "JetBrainsMono" "DroidSansMono" ]; })
   ];
 
   environment.pathsToLink = [ "/share/zsh"  "/share/fish" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    firefox
    git
    unzip
    nvidia-offload
    glxinfo
    vulkan-tools
    glmark2
  ];


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  programs.ssh.startAgent = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

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

