# check https://github.com/meain/nur-packages
{ lib
, stdenvNoCC
, fetchFromGitHub
, gtk3
, gnome-themes-extra
, gtk-engine-murrine
, sassc
, accentColor ? "default"
}:
stdenvNoCC.mkDerivation rec {
  pname = "fluent-gtk-theme";
  version = "3579679d5a91aaab5c61a4f1ff5539ce38db8a92"; # version from 2022-04-28

  src = fetchFromGitHub {
    repo = "Fluent-gtk-theme";
    owner = "vinceliuice";
    rev = version;
    sha256 = "sha256-jt33MXT3Q6hZJ8KXEA8v6q7w/1L1AJr5iSHxNvse1iQ=";
  };

  nativeBuildInputs = [ gtk3 sassc ];

  buildInputs = [ gnome-themes-extra ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  preInstall = ''
    mkdir -p $out/share/themes
  '';

  installPhase = ''
    runHook preInstall
    bash install.sh -d $out/share/themes -t ${accentColor} --tweaks float
    runHook postInstall
  '';

  meta = with lib; {
    description = "A Material Design theme for GNOME/GTK based desktop environments.";
    homepage = "https://github.com/vinceliuice/Fluent-gtk-theme";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
