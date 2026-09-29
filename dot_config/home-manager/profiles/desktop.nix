{ pkgs, ... }:

{
  imports = [
    ../modules/neovim.nix
    ../modules/fonts.nix
  ];

  home.packages =
    (with pkgs; [
      wl-clipboard # satty
      brightnessctl # change-brightness
      ddcutil # change-brightness
      playerctl # hyprland(bind.conf), hyprlock(songdetail)

      nwg-drawer # waybar
      kdePackages.qtdeclarative # qmlls QML modules (QtQuick etc.)
    ])
    ++ pkgs.local.wallpapers;

  programs.quickshell = {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
    };
  };
}
