{ pkgs, packages, ... }:

{
  imports = [
    ../modules/neovim.nix
    ../modules/fonts.nix
  ];

  home.packages = [
    pkgs.wl-clipboard   # satty
    pkgs.brightnessctl  # change-brightness
    pkgs.ddcutil        # change-brightness
    pkgs.playerctl      # hyprland(bind.conf), hyprlock(songdetail)

    pkgs.nwg-drawer     # waybar
  ] ++ packages.wallpapers;

  programs.quickshell = {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
    };
  };
}
