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

    # GUI Deps
    pkgs.nwg-drawer     # waybar

    # CLI Apps
    pkgu.chezmoi
    pkgu.terraform
    pkgu.wakatime-cli
  ];

  programs.home-manager.enable = true;

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
        packages.gtk-css-language-server    # neovim_lsp[gtkcssls]
        packages.vscode-css-language-server # neovim_lsp[cssls]
        pkgu.vscode-langservers-extracted   # neovim_lsp[cssls, eslint, html, jsonls]
        pkgu.nixd                           # neovim_lsp[nixd]
        pkgu.terraform                      # terraform-ls
        pkgu.terraform-ls                   # neovim_lsp[terraformls]

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

