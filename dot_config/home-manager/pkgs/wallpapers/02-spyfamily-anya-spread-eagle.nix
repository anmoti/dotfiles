{ stdenv, fetchurl, imagemagick }:

let
  id = "02";
  ext = "png";
in
stdenv.mkDerivation rec {
  name = "${id}";
  pname = "${id}-spyfamily-anya-spread-eagle";

  src = fetchurl {
    # https://x.com/_tatsuyaendo_/status/1512801651459239937 
    url = "https://pbs.twimg.com/media/FP6NDzNacAYeLhr.jpg?name=orig";
    hash = "sha256-DgUyC7ecmNC2aETZjnio6Z6D4QNB/CERwY3OdzTKeJo=";
  };

  logoSrc = fetchurl {
    urls = [
      "https://spy-family.net/assets/img/common/logo.svg"
      "https://upload.wikimedia.org/wikipedia/commons/a/a4/Spy_×_Family_logo.svg"
    ];
    hash = "sha256-jZ0TSBYse2ZRHNPGk6S7u1RK7//sClNPnQ83Nz+bL8I=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ imagemagick ];

  installPhase = ''
    mkdir -p $out/share/wallpapers

    SOURCE_WIDTH=$(magick ${src} -format "%w" info:)

    LOGO_WIDTH=$(awk "BEGIN {print $SOURCE_WIDTH * 0.5}")

    # 画像の左上のピクセルの色を背景色とする
    BG_COLOR=$(magick $src -format "%[pixel:p{0,0}]" info:)

    # SVGロゴを描画して透過PNGで出力
    magick \
      -density 1200 \
      -background none \
      ${logoSrc} \
      -resize "''${LOGO_WIDTH}x" \
      logo.png

    LOGO_HEIGHT=$(magick logo.png -format "%h" info:)

    Y_OFFSET=$(awk "BEGIN {print int($LOGO_HEIGHT * 0.3)}")

    # ソース画像の上部にロゴを合成
    magick \
      -background "$BG_COLOR" \
      $src \
      -splice 0x$Y_OFFSET \
      logo.png \
      -gravity north \
      -composite \
      composite.png

    # 画像を中央に配置し、背景色で4kキャンバスに拡張
    magick \
      composite.png \
      -gravity center \
      -background "$BG_COLOR" \
      -extent 3840x2160 \
      $out/share/wallpapers/${id}.${ext}
  '';

  passthru = {
    inherit id ext;
    filename = "${id}.${ext}";
  };
}

