{ pkgs, ... }:

{
  config = {
    home-manager.users.michel = { pkgs, ... }: {
      services.wlsunset = {
        enable = true;
        longitude = "-3.75";
        latitude = "-38.54";
        temperature.day = 6500;
        temperature.night = 3500;
      };
    };
  };
}