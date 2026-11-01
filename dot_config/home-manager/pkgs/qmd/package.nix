{
  runCommand,
  coreutils,
  qmd,
}:

# Upstream's wrapper exports a Nix glibc in LD_LIBRARY_PATH and then runs `uname -s`.
# On a non-NixOS host that resolves to the host's /usr/bin/uname, which aborts with
# "stack smashing detected" (glibc mismatch). Use Nix's uname instead.
runCommand "qmd" { inherit (qmd) meta; } ''
  mkdir -p $out/bin
  sed 's|\$(uname -s)|$(${coreutils}/bin/uname -s)|' ${qmd}/bin/qmd > $out/bin/qmd
  chmod +x $out/bin/qmd
  grep -q '${coreutils}/bin/uname' $out/bin/qmd
''
