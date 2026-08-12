{ pkgs, package ? pkgs.proto, ... }:

let
  protoCompletions = pkgs.runCommand "proto-completions-${package.version}" {
    nativeBuildInputs = [
      pkgs.installShellFiles
    ];
  } ''
    export HOME="$TMPDIR"

    installShellCompletion --cmd proto \
      --bash <(${package}/bin/proto completions --shell bash) \
      --fish <(${package}/bin/proto completions --shell fish) \
      --zsh <(${package}/bin/proto completions --shell zsh)
  '';
in
pkgs.symlinkJoin {
  name = "proto-with-completions-${package.version}";

  paths = [
    package
    protoCompletions
  ];

  meta = package.meta;
}
