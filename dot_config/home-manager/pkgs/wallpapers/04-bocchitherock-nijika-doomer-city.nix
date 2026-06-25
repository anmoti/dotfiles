{ stdenv, fetchurl }:

let
  id = "04";
  ext = "png";
in
stdenv.mkDerivation {
  name = "${id}";
  pname = "${id}-bocchitherock-nijika-doomer-city";

  src = fetchurl {
    # Source:
    # https://www.wallwidgy.app/wallpaper/anime-girl-slavic-city
    url = "https://raw.githubusercontent.com/not-ayan/storage/3d1a5212fa4d8ad22ac0c68acebdc4441947ad06/main/anime-girl-slavic-city.png";
    hash = "sha256-blTbYWY9x6jYRXObiA5iEZDZf7ABEyD4mdpK46zB8C4=";
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
