{ config, pkgs, inputs, ... }:
# Copied from https://github.com/Misterio77/nix-config
let
  wofi = pkgs.wofi.overrideAttrs (oa: {
    patches = (oa.patches or [ ]) ++ [
      ./wofi-run-shell.patch # Fix for https://todo.sr.ht/~scoopta/wofi/174
    ];
  });
in {
  home.packages = [ wofi ];

  xdg.configFile."wofi/config".text = ''
    image_size=24
    columns=2
    allow_images=true
    insensitive=true
    run-always_parse_args=true
    run-cache_file=/dev/null
    run-exec_search=true
  '';

  xdg.configFile."wofi/style.css".text = import ./wofi-style.nix {
    inherit (config.colorScheme) palette;
    inherit (inputs.nix-colors.lib-core.conversions) hexToRGBString;
  };
}
