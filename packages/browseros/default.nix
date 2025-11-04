{
  appimageTools,
  fetchurl,
}:
let
  version = "0.28.1";
  pname = "browseros";

  src = fetchurl {
    url = "https://github.com/browseros-ai/BrowserOS/releases/download/v${version}/BrowserOS_v0.28.1_x64.AppImage";
    hash = "sha256-YY3g0xNr/Jm4Q1PJSg27vO+M5jur/lM2a6iTN03BbCA=";
  };
in
appimageTools.wrapType2 {
  inherit pname version src;
  meta = {
    description = "Open-source agentic browser (Chromium fork)";
    homepage = "https://www.browseros.com/";
    platforms = [ "x86_64-linux" ];
  };
}
