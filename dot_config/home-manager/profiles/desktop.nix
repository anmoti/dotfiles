{ config, pkgs, ... }:

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
    ++ [
      pkgs.local.catppuccin-openbox
      pkgs.local.nestwm
    ]
    ++ pkgs.local.wallpapers;

  home.pointerCursor = {
    enable = true;
    package = pkgs.catppuccin-cursors.mochaSapphire;
    name = "catppuccin-mocha-sapphire-cursors";
    size = 24;
    gtk.enable = true;
    hyprcursor.enable = true;
  };

  programs.quickshell = {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
    };
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        (catppuccin-fcitx5.override {
          withRoundedCorners = true;
         })
        qt6Packages.fcitx5-qt
        fcitx5-gtk
        (fcitx5-skk.override { enableQt = true; })
        qt6Packages.fcitx5-configtool
      ];
    };
  };

  # home.sessionVariables is only sourced by shells; export these to
  # environment.d so Hyprland (started by systemd, not a shell) sees them
  systemd.user.sessionVariables = {
    inherit (config.home.sessionVariables)
      XMODIFIERS
      SDL_IM_MODULE
      GLFW_IM_MODULE
      XCURSOR_THEME
      XCURSOR_SIZE
      HYPRCURSOR_THEME
      HYPRCURSOR_SIZE
      ;
  };
}
