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

    # CLI Apps
    unstable.chezmoi
    docker-compose
    unstable.wakatime-cli
    opentofu
  ];
}
