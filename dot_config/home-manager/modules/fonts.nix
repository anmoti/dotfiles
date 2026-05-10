{ pkgs, ... }:

{
  home.packages = [
    pkgs.google-fonts
    pkgs.noto-fonts-cjk-sans
    pkgs.noto-fonts-cjk-serif
    pkgs.meslo-lg
    pkgs.monaspace
    pkgs.mona-sans
    pkgs.hackgen-font
    pkgs.hackgen-nf-font
    pkgs.nerd-fonts.symbols-only
  ];

  fonts.fontconfig.enable = true;
}
