{ stdenv, fetchurl }:

let
  id = "01";
  ext = "jpeg";
in
stdenv.mkDerivation {
  name = "${id}";
  pname = "${id}-bluearchive-game-development-department";

  src = fetchurl {
    # https://x.com/heart_Stab419/status/1735616603046531084 
    url = "https://pbs.twimg.com/media/GBYl1uIb0AANSix.jpg?name=orig";
    hash = "sha256-XPrQtn1IpYECNCwoZOFTs9ivc78dzAoXlH0thkzYpU4=";
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

