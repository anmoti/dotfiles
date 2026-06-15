{ pkgs, ... }:

{
  systemd.user.sessionVariables = {
    SHELL = "${pkgs.zsh}/bin/zsh";
  };

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
  };

  programs.zoxide.enable = true;

  programs.oh-my-posh = {
    enable = true;
    configFile = "~/.config/oh-my-posh/default.omp.yaml";
  };
}
