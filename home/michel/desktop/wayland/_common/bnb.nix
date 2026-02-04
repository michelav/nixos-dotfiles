_: {
  bnb.vpn = {
    enable = true;
    settings = {
      user = "f132012";
      disable-ipv6 = true;
    };
  };

  home.persistence."/persist" = {
    directories = [
      ".local/share/remmina"
      ".config/remmina"
    ];
    files = [ ".gp-saml-gui-cookies" ];
  };
}
