# Upstream's flake only exposes devShells, so this wraps the published static binary.
{
  stdenvNoCC,
  fetchurl,
  lib,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "shuck";
  version = "0.2.11";

  src = fetchurl {
    url = "https://github.com/ewhauser/shuck/releases/download/v${finalAttrs.version}/shuck-cli-x86_64-unknown-linux-musl.tar.xz";
    hash = "sha256-U5ZJNVvtfZ3TLIPWIvNWjPY0V9URn+fcKVUV4O3kgpc=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 shuck $out/bin/shuck
    runHook postInstall
  '';

  meta = {
    description = "Fast shell linter, formatter, and LSP server with zsh support";
    homepage = "https://github.com/ewhauser/shuck";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "shuck";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
