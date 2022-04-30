# check https://github.com/meain/nur-packages
{ lib
, stdenvNoCC
, fetchFromGitHub
, gtk3
}:
stdenvNoCC.mkDerivation rec {
  pname = "fluent-icon-theme";
  version = "5e0f2188bc16046de4c0c5632d671a05d4fd2234"; # version from 2022-04-13

  src = fetchFromGitHub {
    repo = "Fluent-icon-theme";
    owner = "vinceliuice";
    rev = version;
    sha256 = "sha256-6sYY01tSxJ7W2ERgviqgUPVJ/CyeUr1PXFq0vEdE75o=";
  };

  nativeBuildInputs = [ gtk3 ];

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  preInstall = ''
    mkdir -p $out/share/icons

    if [ -d "$out/share/icons/Fluent-cursors" ]; then
      rm -r "$out/share/icons/Fluent-cursors"
    fi

    if [ -d "$out/share/icons/Fluent-dark-cursors" ]; then
      rm -r "$out/share/icons/Fluent-dark-cursors"
    fi
  '';

  installPhase = ''
    runHook preInstall
    bash install.sh -d $out/share/icons -r

    cp -r cursors/dist $out/share/icons/Fluent-cursors
    cp -r cursors/dist-dark $out/share/icons/Fluent-dark-cursors

    runHook postInstall
  '';

  meta = with lib; {
    description = "Fluent icon theme for linux desktops.";
    homepage = "https://github.com/vinceliuice/Fluent-gtk-theme";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}