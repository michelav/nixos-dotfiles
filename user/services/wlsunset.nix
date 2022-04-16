{ lib, pkgs, config, ... }:

{
  services.wlsunset = {
    enable = true;
    longitude = "-3.75";
    latitude = "-38.54";
    temperature.day = 6500;
    temperature.night = 4000;
  };
}
