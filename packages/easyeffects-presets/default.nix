{ lib, stdenvNoCC, fetchFromGitHub, ... }:
stdenvNoCC.mkDerivation rec {
  pname = "easyeffects-presets";
  version = "master";
  src = fetchFromGitHub {
    owner = "JackHack96";
    repo = "EasyEffects-Presets";
    rev = "${version}";
    sha256 = "";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  preInstall = ''
    mkdir -p $out/output
  '';

  installPhase = ''
    runHook preInstall
    cp *.json $out/output
    cp -r irs/ $out/output
    runHook postInstall
  '';
  meta = {
    description = " Collection of PulseEffects presets";
    homepage = "https://github.com/JackHack96/EasyEffects-Presets/";
    license = lib.licenses.mit;
  };
}
