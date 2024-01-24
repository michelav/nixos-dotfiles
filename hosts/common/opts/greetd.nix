{ pkgs, ... }:
let
  hyprland-vega = pkgs.writeTextFile {
    name = "hyprland-vega";
    destination = "/bin/hyprland-vega";
    executable = true;
    text = let
      intel = "0000:00:02.0";
      # nvidia = "0000:00:01.0";
    in ''
      export WLR_DRM_DEVICES=$(udevadm info -q property --value -n /dev/dri/by-path/pci-${intel}-card | grep /dev/dri/card)
      Hyprland
    '';
  };
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
in {
  environment.systemPackages = [ hyprland-vega ];
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command =
          "${tuigreet} --greeting 'Welcome to Vega!' --asterisks --remember --remember-user-session --time --cmd hyprland-vega";
        user = "greeter";
      };
      initial_session = {
        command = "hyprland-vega";
        user = "michel";
      };
    };
  };
}
