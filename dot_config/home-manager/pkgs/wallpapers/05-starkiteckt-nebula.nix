{ stdenv, fetchurl }:

let
  id = "05";
  ext = "png";
in
stdenv.mkDerivation {
  name = "${id}";
  pname = "${id}-starkiteckt-nebula";

  src = fetchurl {
    # Source (uploaded by the artist, Starkiteckt Designs; 5120x3200):
    # https://wallhaven.cc/w/28mpg6
    url = "https://w.wallhaven.cc/full/28/wallhaven-28mpg6.png";
    hash = "sha256-dhfgz2iD8xzZPuEdC8Y/rRQlqKlfxl+qr2Ry/dvW7g8=";
  };

  dontUnpack = true;

  installPhase = ''
    install -Dm0644 $src $out/share/wallpapers/${id}.${ext}
  '';

  passthru = {
    inherit id ext;
    filename = "${id}.${ext}";
  };
}
