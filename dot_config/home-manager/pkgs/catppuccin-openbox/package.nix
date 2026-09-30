{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
}:

stdenvNoCC.mkDerivation {
  pname = "catppuccin-openbox";
  version = "0-unstable-2024-07-20";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "openbox";
    rev = "bb1c8662898b156e2b5425d4616bcc8ae4cfeeb2";
    hash = "sha256-56da/tjKvFhBbDF6uBau/KMznWIKeCK6jynbRJRkpTc=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes
    cp -r themes/* $out/share/themes/

    runHook postInstall
  '';

  meta = {
    description = "Soothing pastel theme for Openbox";
    homepage = "https://github.com/catppuccin/openbox";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
