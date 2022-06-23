# Static networking configuration. It isn't used at moment.
{ lib, ... }:
{
  networking = {
    useDHCP = false;
    interfaces = {
      enp7s0.useDHCP = true;
      wlp0s20f3.useDHCP = true;
    };
  };
}
