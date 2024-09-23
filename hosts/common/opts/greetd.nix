{ pkgs, config, ... }:
let
  hyprland-vega = pkgs.writeTextFile {
    name = "hyprland-vega";
    destination = "/bin/hyprland-vega";
    executable = true;
    text =
      let
        intel = "0000:00:02.0";
        nvidia = "0000:01:00.0";
        mode = if config.hardware.nvidia.prime.sync.enable then "sync" else "";
      in
      ''
        mode="${mode}"
        intel_card=$(udevadm info -q property --value -n /dev/dri/by-path/pci-${intel}-card | grep /dev/dri/card)
        nvidia_card=$(udevadm info -q property --value -n /dev/dri/by-path/pci-${nvidia}-card | grep /dev/dri/card)
        if [ -z "$mode" ]; then
          export AQ_DRM_DEVICES="$intel_card:$nvidia_card"
        else
          export AQ_DRM_DEVICES="$nvidia_card:$intel_card"
        fi
        Hyprland
      '';
  };
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
in
{
  environment.systemPackages = [ hyprland-vega ];
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${tuigreet} --greeting 'Welcome to Vega!' --asterisks --remember --remember-user-session --time --cmd hyprland-vega";
        user = "greeter";
      };
      initial_session = {
        command = "hyprland-vega";
        user = "michel";
      };
    };
  };
}
