{ stdenv, fetchurl }:

let
  id = "03";
  ext = "jpeg";
in
stdenv.mkDerivation {
  name = "${id}";
  pname = "${id}-feature-spacer";

  src = fetchurl {
    # https://dribbble.com/shots/1355879
    # https://geometrieva.medium.com/9c97214b4d92
    urls = [
      "https://cdn.dribbble.com/users/108482/screenshots/1355879/attachments/193117/Space-Desktop.jpg"
      # different hash, but looks like the same image
      # "https://miro.medium.com/v2/1*X0YAhnDmAmUXec83Y1IDZA.jpeg"
    ];
    hash = "sha256-jam+IhP+NR7b6sylajfrSMuALUa/qZqyn8rj1gqPFIE=";
    # hash = "sha256-Ihq+O+oYBdPaHMM6LcmUi8VP21UwrebTfDnrbt9wVqU=";
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

