{
  config,
  lib,
  pkgs,
  ...
}:
let
  fonts = config.stylix.fonts;
  basePackage = pkgs.zathura;
  sessionWrapper = pkgs.writeShellApplication {
    name = "zathura";
    text = ''
      if [ "''${XDG_CURRENT_DESKTOP,,}" = umbriel ]; then
        exec ${lib.getExe basePackage} --config-dir "${config.xdg.configHome}/zathura-umbriel" "$@"
      fi
      exec ${lib.getExe basePackage} "$@"
    '';
  };
  package = pkgs.symlinkJoin {
    name = "zathura-session-aware";
    paths = [ basePackage ];
    postBuild = ''
      ln -sf ${sessionWrapper}/bin/zathura "$out/bin/zathura"
    '';
  };
in
{
  stylix.targets.zathura.enable = true;

  programs.zathura = {
    enable = true;
    inherit package;
    options = {
      selection-clipboard = "clipboard";
      font = "${fonts.sansSerif.name} 12";
      recolor = true;
    };
  };

  xdg.configFile."zathura-umbriel/zathurarc".text = ''
    include ${config.xdg.configHome}/zathura/zathurarc
    include noctaliarc
  '';
}
