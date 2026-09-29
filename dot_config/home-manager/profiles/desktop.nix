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
        fcitx5-skk
        qt6Packages.fcitx5-configtool
      ];
    };
  };

  nixpkgs.overlays = [
    (final: prev: {
      fcitx5-skk = prev.fcitx5-skk.overrideAttrs (old: {
        cmakeFlags = [
          "-DENABLE_QT=TRUE"
          "-DSKK_PATH=${prev.skkDictionaries.l}/share/skk"
        ];
        buildInputs = (old.buildInputs or []) ++ [
          prev.qt6.qtbase
          prev.qt6Packages.fcitx5-qt
        ];
        nativeBuildInputs = (old.nativeBuildInputs or []) ++ [
          prev.qt6.wrapQtAppsHook
        ];
      });
    })
  ];
}
