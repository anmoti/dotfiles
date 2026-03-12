# Reference: https://github.com/nix-community/nur-combined/blob/4b8d9af/repos/shackra/packages/gtk-css-language-server/default.nix
{
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  vala,
  pkg-config,
  json-glib,
  jsonrpc-glib,
  gtk4,
  git,
  lib
}:

stdenv.mkDerivation {
  pname = "gtk-css-language-server";
  version = "2023.12.19";

  src = fetchFromGitHub {
    owner = "JCWasmx86";
    repo = "GTKCssLanguageServer";
    rev = "dcbe75012d2d26fbca2729cee014e4860e31fa53";
    hash = "sha256-KKC5ZLIjCAgC/Qp1AhAGLWlxM/yApEfAL8ppHmSBb74=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    git
  ];

  buildInputs = [
    json-glib
    jsonrpc-glib
    gtk4
  ];

  postInstall = ''
    ln -s $out/bin/gtkcsslanguageserver $out/bin/gtk-css-language-server
  '';

  meta = with lib; {
    description = "Language server for GTK CSS";
    homepage = "https://github.com/JCWasmx86/GTKCssLanguageServer";
    license = licenses.gpl3;
    platforms = platforms.linux;
    mainProgram = "gtk-css-language-server";
  };
}
