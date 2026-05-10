{ pkgs, packages, ... }:

{
  imports = [
    ./modules/base.nix
    ./modules/zsh.nix
    ./modules/neovim.nix
    ./modules/fonts.nix
  ];
  
  targets.genericLinux.enable = true;

  home.packages = [
    # CLI Deps
    pkgs.wl-clipboard   # satty
    pkgs.brightnessctl  # change-brightness
    pkgs.ddcutil        # change-brightness
    pkgs.playerctl      # hyprland(bind.conf), hyprlock(songdetail)

    # GUI Deps
    pkgs.nwg-drawer     # waybar
  ] ++ packages.wallpapers;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}

