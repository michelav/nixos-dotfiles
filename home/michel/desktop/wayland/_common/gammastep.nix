{ pkgs, ... }: {
  home.packages = [ pkgs.gammastep ];
  services.gammastep = {
    enable = true;
    provider = "manual";
    latitude = -3.75;
    longitude = -38.54;
    temperature = {
      day = 6500;
      night = 4500;
    };
    settings = { general.adjustment-method = "wayland"; };
  };
}
