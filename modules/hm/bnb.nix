{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.bnb.vpn;
  inherit (lib)
    types
    mkOption
    mkEnableOption
    mkIf
    mapAttrsToList
    concatStrings
    ;
  inherit (config) xdg;
  inherit (inputs.nixpkgs-stable.legacyPackages."x86_64-linux") remmina;
  gpclient = inputs.gp-openconnect.packages."x86_64-linux".default;
  bnb-vpn = pkgs.writeTextFile {
    name = "bnb-vpn";
    destination = "/bin/bnb-vpn";
    executable = true;
    text =
      let
        oc = "${pkgs.openconnect}/bin/openconnect";
        hip = "${pkgs.openconnect}/libexec/openconnect/hipreport.sh";
      in
      ''
        sudo -E ${oc} --config=${xdg.configHome}/bnb/vpn-config --protocol=gp --csd-wrapper=${hip} "$@"
      '';
  };
in
{
  options.bnb.vpn = {
    enable = mkEnableOption "Wether enable vpn for BNB";
    settings = mkOption {
      type =
        with types;
        attrsOf (oneOf [
          bool
          str
        ]);
      default = { };
      description = ''
        Default arguments to connect to {command}`BNB VPN`. An empty set
        disables configuration generation.
      '';
      example = {
        user = "T9000";
        disable-ipv6 = true;
      };
    };
  };
  config = mkIf cfg.enable {
    home.packages = [
      pkgs.openconnect
      pkgs.gp-saml-gui
      remmina
      bnb-vpn
      gpclient
    ];
    xdg.configFile."bnb/vpn-config" = mkIf (cfg.settings != { }) {
      text = concatStrings (
        mapAttrsToList (
          n: v: if v == false then "" else (if v == true then n else n + "=" + builtins.toString v) + "\n"
        ) cfg.settings
      );
    };
  };
}
