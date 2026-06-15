{ pkgs, pkgu, packages, ... }:

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
  
  home.packages = [
    # CLI Deps
    pkgs.doppler  # chezmoi
    pkgs.gh       # dot_gitconfig

    # CLI Apps
    pkgu.chezmoi
    pkgs.docker-compose
    pkgu.wakatime-cli
    pkgs.opentofu
    packages.claude-code
  ];
}
