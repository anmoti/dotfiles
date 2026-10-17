{ pkgs, ... }:

{
  home.packages = [
    pkgs.google-fonts
    pkgs.noto-fonts-cjk-sans
    pkgs.noto-fonts-cjk-serif
    pkgs.meslo-lg
    pkgs.monaspace
    pkgs.hackgen-font
    pkgs.hackgen-nf-font
    pkgs.nerd-fonts.symbols-only
  ];

  fonts.fontconfig = {
    enable = true;
    # LANG=en_US では CJK 漢字が KR/SC 字形に解決されるため、JP を明示する
    defaultFonts = {
      sansSerif = [ "Noto Sans" "Noto Sans CJK JP" ];
      serif = [ "Noto Serif" "Noto Serif CJK JP" ];
      monospace = [ "Noto Sans Mono CJK JP" ];
    };
  };
}
