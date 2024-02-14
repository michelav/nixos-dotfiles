_: {
  bnb.vpn = {
    enable = true;
    settings = {
      user = "f132012";
      disable-ipv6 = true;
    };
  };

  home.persistence."/persist/home/michel" = {
    allowOther = true;
    directories = [ ".local/share/remmina" ".config/remmina" ];
  };
}
