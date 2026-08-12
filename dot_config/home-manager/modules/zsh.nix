{ config, pkgs, packages, ... }:

{
  home.packages = [
    packages.proto
  ];

  systemd.user.sessionVariables = {
    SHELL = "${pkgs.zsh}/bin/zsh";
  };

  home.sessionVariables = {
    PROTO_HOME = "${config.xdg.dataHome}/proto";
    RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
    CARGO_HOME = "${config.xdg.dataHome}/cargo";
  };

  home.sessionPath = [
  "${config.xdg.dataHome}/cargo/bin"
  ];

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    historySubstringSearch.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
      ];
    };
    initContent = ''
      eval "$(proto activate zsh)"

      launch() {
        ${pkgs.python3}/bin/python -c '
import subprocess
import sys

subprocess.Popen(
    sys.argv[1:],
    stdin=subprocess.DEVNULL,
    stdout=subprocess.DEVNULL,
    stderr=subprocess.DEVNULL,
    start_new_session=True,
)
' "$@"
      }
    '';
  };

  programs.zoxide.enable = true;

  programs.direnv.enable = true;

  programs.oh-my-posh = {
    enable = true;
    configFile = "~/.config/oh-my-posh/default.omp.yaml";
  };
}
