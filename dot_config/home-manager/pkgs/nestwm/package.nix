# labwc nested in the host Wayland session: floating windows, translucent
# background, host cursors/keymap/clipboard/fcitx5. Development happens in
# the wlroots/labwc forks; patches/ is `git format-patch` of their branches.
{
  lib,
  stdenvNoCC,
  labwc,
  wlroots_0_20,
  wl-clipboard,
  diffutils,
  makeDesktopItem,
  copyDesktopItems,
}:

let
  patchesIn = dir: map (f: dir + "/${f}") (lib.sort lib.lessThan (lib.attrNames (builtins.readDir dir)));

  wlroots = wlroots_0_20.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ patchesIn ./patches/wlroots;
  });

  labwc' = (labwc.override { wlroots_0_20 = wlroots; }).overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ patchesIn ./patches/labwc;
  });
in
stdenvNoCC.mkDerivation {
  pname = "nestwm";
  inherit (labwc') version;

  src = ./.;

  nativeBuildInputs = [ copyDesktopItems ];

  installPhase = ''
    runHook preInstall

    install -Dm644 config/rc.xml config/autostart config/shutdown -t $out/share/nestwm/config
    install -Dm755 clipsync -t $out/share/nestwm
    install -Dm755 nestwm.sh $out/bin/nestwm
    substituteInPlace $out/bin/nestwm \
      --replace-fail @share@ $out/share/nestwm \
      --replace-fail @path@ ${
        lib.makeBinPath [
          labwc'
          wl-clipboard
          diffutils
        ]
      }

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "nestwm";
      desktopName = "NestWM";
      comment = "Floating window manager nested in the current session";
      exec = "nestwm";
      categories = [ "System" ];
    })
  ];

  passthru = {
    inherit wlroots;
    labwc = labwc';
  };

  meta = {
    description = "labwc nested in the current Wayland session";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    mainProgram = "nestwm";
  };
}
