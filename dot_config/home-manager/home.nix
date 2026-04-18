{ pkgs, pkgu, packages, lib, ... }:

{
  home.username = "anmoti";
  home.homeDirectory = "/home/anmoti";
  home.stateVersion = "25.11";

  home.packages = [

    # CLI Deps
    pkgs.oh-my-posh     # zshrc
    pkgs.fd             # zshrc
    pkgs.fzf            # zshrc
    pkgs.bat            # zshrc
    pkgs.zoxide         # zshrc
    pkgs.wl-clipboard   # satty
    pkgs.doppler        # chezmoi
    pkgs.gh             # dot_gitconfig
    pkgs.brightnessctl  # change-brightness
    pkgs.ddcutil        # change-brightness
    pkgs.playerctl      # hyprland(bind.conf), hyprlock(songdetail)

    # GUI Deps
    pkgs.nwg-drawer     # waybar

    # CLI Apps
    pkgu.chezmoi
    pkgu.terraform
    pkgu.wakatime-cli

    # Font Deps
    pkgs.google-fonts
    pkgs.noto-fonts-cjk-sans
    pkgs.noto-fonts-cjk-serif
    pkgs.meslo-lg
    pkgs.monaspace
    pkgs.mona-sans
    pkgs.hackgen-font
    pkgs.hackgen-nf-font
    pkgs.nerd-fonts.symbols-only

  ] ++ packages.wallpapers;

  programs.home-manager.enable = true;
  fonts.fontconfig.enable = true;

  programs.neovim = {
    enable = true;

    extraWrapperArgs = [
      "--run" "export HOST_PATH=$PATH"
      "--set" "PATH" (lib.makeBinPath [
        pkgs.bash
        pkgs.coreutils                      # sha256sum (blink.cmp), tee (:SudoWrite)
        pkgs.curl
        pkgs.git
        pkgs.fd                             # Snacks.nvim
        pkgs.ripgrep                        # Snacks.nvim picker.grep()
        pkgs.wl-clipboard                   # clipboard provider

        pkgu.bash-language-server           # neovim_lsp[bashls]
        pkgu.lua-language-server            # neovim_lsp[lua_ls]
        pkgu.yaml-language-server           # neovim_lsp[yamlls]
        packages.gtk-css-language-server    # neovim_lsp[gtkcssls]
        packages.vscode-css-language-server # neovim_lsp[cssls]
        pkgu.vscode-langservers-extracted   # neovim_lsp[cssls, eslint, html, jsonls]
        pkgu.basedpyright                   # neovim_lsp[basedpyright(basedpyright-langserver)]
        pkgu.ruff                           # neovim_lsp[ruff]
        pkgu.mypy                           # nvim-lsp[mypy]
        pkgu.nixd                           # neovim_lsp[nixd]
        pkgu.docker-language-server         # neovim_lsp[docker-language-server]
        pkgu.terraform                      # terraform-ls
        pkgu.terraform-ls                   # neovim_lsp[terraformls]
        pkgu.copilot-language-server        # copilot.lua

        pkgu.chezmoi                        # chezmoi.nvim
        pkgu.wakatime-cli                   # vim-wakatime
      ])
    ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}

