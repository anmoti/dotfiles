{ pkgs, pkgu, packages, lib, ... }:

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

  home.packages = [
    # CLI Deps
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
    pkgs.docker-compose
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

  fonts.fontconfig.enable = true;

  programs.home-manager = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    historySubstringSearch.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
      ];
    };
  };

  programs.zoxide.enable = true;

  programs.oh-my-posh = {
    enable = true;
    configFile = "~/.config/oh-my-posh/default.omp.json";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
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

        pkgs.bash-language-server           # neovim_lsp[bashls]
        pkgs.lua-language-server            # neovim_lsp[lua_ls]
        pkgs.yaml-language-server           # neovim_lsp[yamlls]
        pkgs.taplo                          # neovim_lsp[taplo]
        packages.gtk-css-language-server    # neovim_lsp[gtkcssls]
        packages.vscode-css-language-server # neovim_lsp[cssls]
        pkgs.vscode-langservers-extracted   # neovim_lsp[cssls, eslint, html, jsonls]
        pkgs.basedpyright                   # neovim_lsp[basedpyright(basedpyright-langserver)]
        pkgs.ruff                           # neovim_lsp[ruff]
        pkgs.mypy                           # nvim-lsp[mypy]
        pkgs.nixd                           # neovim_lsp[nixd]
        pkgs.docker-language-server         # neovim_lsp[docker-language-server]
        pkgs.copilot-language-server        # copilot.lua

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

