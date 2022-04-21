{ lib, pkgs, config, ... }:

{
  services.wlsunset = {
    enable = true;
    longitude = "-38.54";
    latitude = "-3.75";
    temperature.day = 6500;
    temperature.night = 4000;
  };
}
