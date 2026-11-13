{ pkgs, ... }:

{
  home.username = "anmoti";
  home.homeDirectory = "/home/anmoti";
  home.stateVersion = "25.11";

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  home.shellAliases = {
    docker = "podman";
  };

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # CLI Deps
    doppler # chezmoi
    gh # dot_gitconfig
    fzf
    # 0.46+ の `jj workspace add --colocate` を使うため unstable
    unstable.jujutsu # jj: workspace 運用

    # CLI Apps
    unstable.chezmoi
    docker-compose
    ghq
    lazygit
    unstable.wakatime-cli
    opentofu
  ];
}
