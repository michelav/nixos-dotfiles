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
        vpn-client = "${pkgs.gp-saml-gui}/bin/gp-saml-gui";
        hip = "${pkgs.openconnect}/libexec/openconnect/hipreport.sh";
      in
      ''
        #!${pkgs.fish}/bin/fish

        argparse 'v/verbose' 's/server=' -- $argv
        if set -q _flag_verbose
          set -f verbose '--verbose'
        else
          set -f csd ${hip}
        end
        ${vpn-client} $verbose --gateway -S $_flag_server -- --csd-wrapper=${hip}
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
