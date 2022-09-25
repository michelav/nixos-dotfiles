# Static networking configuration. It isn't used at moment.
{ lib, ... }: {
  networking.wireless = {
    iwd = {
      enable = true;
      settings = {
        Network = { EnableIPv6 = true; };
        Settings = {
          AutoConnect = true;
          Hidden = true;
        };
      };
    };
  };
}
