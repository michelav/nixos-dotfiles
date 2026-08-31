{ pkgs, ... }:
{
  home.packages = [ pkgs.nemo-with-extensions ];
  xdg.desktopEntries.nemo = {
    name = "Nemo";
    exec = "${pkgs.nemo-with-extensions}/bin/nemo";
  };
}
